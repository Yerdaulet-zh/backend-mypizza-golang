// Package main is the entrypoint for the project.
// It initializes the core services and starts the gRPC, HTTP runtime.
package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/cmd/servers"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/cache/redis"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/config"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
	postgre "github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/repo"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/tracing"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/service"

	"go.opentelemetry.io/otel/sdk/trace"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer cancel()

	logger, tracer, client, rdb := loadComponents(ctx)

	if err := run(ctx, logger, tracer, client, rdb); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context, logger ports.Logger, tracer *trace.TracerProvider, client ports.Database, rdb ports.Redis) error {
	defer func() {
		logger.Info(ctx, "Closing infrastructure connections...")
		if err := client.Close(); err != nil {
			logger.Error(ctx, "Postgre close error", "error", err)
		}
		if err := rdb.Close(); err != nil {
			logger.Error(ctx, "Redis close error", "error", err)
		}
		// Graceful shutdown of tracer
		shutdownCtx, cancelTracer := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancelTracer()
		if err := tracer.Shutdown(shutdownCtx); err != nil {
			logger.Error(ctx, "Failed to shutdown tracer", "error", err)
		}
		logger.Info(ctx, "Done")
	}()

	logger.Info(ctx, "Loading HTTP Server config")
	httpConfig := config.NewHttpConfig()
	logger.Info(ctx, "Successfully loaded HTTP Server config")

	productRepo := repo.NewProductRepository(client.GetGormDB(), logger)
	productService := service.NewProductService(productRepo, logger)
	productHandler := handlers.NewProductHandler(productService)

	mapBusinessHandler := servers.MapBusinessRoutes(productHandler, logger, tracer, rdb)
	mapManagementRoutes := servers.MapManagementRoutes(logger, client)

	go func() {
		if err := servers.Run(ctx, logger, mapManagementRoutes, httpConfig.HttpManagementAddr, httpConfig.GracefullShutdown, "Management"); err != nil {
			logger.Error(ctx, "HTTP Management server error while shutting down", "error", err)
		}
	}()

	if err := servers.Run(ctx, logger, mapBusinessHandler, httpConfig.HttpBusinessAddr, httpConfig.GracefullShutdown, "Business"); err != nil {
		logger.Error(ctx, "HTTP Business server error while shutting down", "error", err)
		os.Exit(1)
	}
	logger.Info(ctx, "Application exited cleanly")
	return nil
}

func loadComponents(ctx context.Context) (ports.Logger, *trace.TracerProvider, *postgre.Client, ports.Redis) {
	// Configuration
	cfg, err := config.NewLoggingConfig()
	if err != nil {
		log.Fatalf("Error initializing config: %v", err)
	}

	// Logger
	logger := logging.NewLogger(cfg)
	logger.Info(ctx, "Logging successfully configured to use the adapter: ", cfg.Adapter())

	// Tracer
	tracer, err := tracing.InitTracer()
	if err != nil {
		logger.Error(ctx, "Failed to init OTel tracer", err)
		os.Exit(1)
	}

	// PostgreSQL
	logger.Info(ctx, "Loading PostgreSQL config")
	postgreConfig, err := config.NewDefaultDBConfig()
	if err != nil {
		logger.Error(ctx, "Failed to load PostgreSQL config", "error", err)
		os.Exit(1)
	}

	logger.Info(ctx, "Connecting to PostgreSQL database")
	client, err := postgre.NewPostgreSQLClient(postgreConfig, logger)
	if err != nil {
		logger.Error(ctx, "Postgresql connection error", "error", err)
		os.Exit(1)
	}
	logger.Info(ctx, "Successful PostgreSQL connection")

	// Redis
	logger.Info(ctx, "Loading redis config")
	redisConfig := config.NewRedisCondfig()

	logger.Info(ctx, "Connecting to redis server")
	rdb := redis.NewRedisClient(logger, redisConfig)
	logger.Info(ctx, "Successful redis connection")

	return logger, tracer, client, rdb
}

// Package servers provides HTTP or gRPC compatible servers to serve client requests.
package servers

import (
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"
	redisV9 "github.com/redis/go-redis/v9"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/cache/redis"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/middleware"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/product"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
	"go.opentelemetry.io/otel/sdk/trace"
)

// Defining middleware
type mw func(http.Handler) http.Handler

func applyMiddlewares(h http.Handler, mws ...mw) http.Handler {
	for _, mw := range mws {
		h = mw(h)
	}
	return h
}

// MapManagementRoutes maps management-related routes (health checks, metrics) to their handlers.
func MapManagementRoutes(logger ports.Logger, client ports.Database) http.Handler {
	mux := http.NewServeMux()

	healthHdl := handlers.NewHealthHandler(client)
	mux.HandleFunc("GET /healthz", healthHdl.Healthz)
	mux.HandleFunc("GET /ready", healthHdl.Ready)

	mux.Handle("GET /metrics", promhttp.Handler())
	return mux
}

func MapBusinessRoutes(productHandler *product.ProductHandler, logger ports.Logger, tracer *trace.TracerProvider, rdb *redisV9.Client) http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("GET /v1/city/category/products", productHandler.GetCityAllCategoriesProducts)
	mux.HandleFunc("POST /v1/city/catalog/product/query", productHandler.CatalogProductQuery)

	// Middlewares
	rateLimiter := redis.NewRateLimiter(rdb)
	middlewares := []mw{
		middleware.NewIPRateLimiter(logger, rateLimiter, 100*time.Second, 100),
	}
	handler := applyMiddlewares(mux, middlewares...)
	return otelhttp.NewHandler(handler, "business-api")
}

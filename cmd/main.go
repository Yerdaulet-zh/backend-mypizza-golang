package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/cmd/server"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer cancel()

	logger := logging.NewStdoutAdapter()

	logger.Info("The server is starting!")

	managementRoutes := server.MapManagementRoutes()

	if err := server.Run(ctx, managementRoutes, ":8080", 5, "Business"); err != nil {
		fmt.Println(ctx, "HTTP Business server error while shutting down", "error", err)
		os.Exit(1)
	}

	logger.Info("Application exited cleanly")
}

package server

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"
)

func Run(ctx context.Context, mux http.Handler, addr string, gracefullShutdown time.Duration, serverName string) error {
	s := &http.Server{
		Addr:           addr,
		Handler:        mux,
		ReadTimeout:    30 * time.Second,
		WriteTimeout:   30 * time.Second,
		MaxHeaderBytes: (512 * 3) * 1024,
	}

	go func() {
		if err := s.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			fmt.Fprintln(os.Stderr, "Server "+serverName+" error:", err)
		}
	}()

	<-ctx.Done()

	shutdownCtx, cancel := context.WithTimeout(context.Background(), gracefullShutdown)
	defer cancel()

	return s.Shutdown(shutdownCtx)
}

package logging

import (
	"log"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/config"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

// NewLogger instantiates a logger adapter directly from an existing configuration struct.
func NewLogger(cfg *config.LoggingConfig) ports.Logger {
	return NewStdoutLogger(cfg)
}

// NewDefaultLogger abstracts the configuration loading and logger creation sequence.
// It keeps components like main.go and test suites clean from repeating this setup.
func NewDefaultLogger(configPath string) ports.Logger {
	cfg, err := config.NewLoggingConfig(configPath)
	if err != nil {
		log.Fatalf("Error initializing logger config from %s: %v", configPath, err)
	}

	return NewLogger(cfg)
}

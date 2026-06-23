package logging

import (
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/config"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

func NewLogger(cfg *config.LoggingConfig) ports.Logger {
	return NewStdoutLogger()
}

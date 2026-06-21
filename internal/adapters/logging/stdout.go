package logging

import (
	"log/slog"
	"os"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

type stdoutAdapter struct {
	logger *slog.Logger
}

func NewStdoutAdapter() ports.Logger {
	hanlder := slog.NewJSONHandler(os.Stdout, nil)
	return &stdoutAdapter{
		logger: slog.New(hanlder),
	}
}

func (s stdoutAdapter) Debug(msg string, args ...interface{}) {
	s.logger.Debug(msg, args...)
}

func (s stdoutAdapter) Info(msg string, args ...interface{}) {
	s.logger.Info(msg, args...)
}

func (s stdoutAdapter) Warn(msg string, args ...interface{}) {
	s.logger.Warn(msg, args...)
}

func (s stdoutAdapter) Error(msg string, args ...interface{}) {
	s.logger.Error(msg, args...)
}

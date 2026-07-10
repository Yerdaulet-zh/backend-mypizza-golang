// Package response provides shared utilities for the adapter layer,
// including standardized HTTP response formats and error mapping from domain to http
// to ensure consistent API communication.
package response

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

// Standart Response Format
type APIResponse struct {
	Data         interface{} `json:"data,omitempty"`
	ErrorMessage string      `json:"error,omitempty"`
	Success      bool        `json:"success"`
}

func Success(ctx context.Context, logger ports.Logger, w http.ResponseWriter, statusCode int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	if err := json.NewEncoder(w).Encode(APIResponse{
		Success: true,
		Data:    data,
	}); err != nil {
		logger.Debug(ctx, err.Error())
	}
}

func Error(ctx context.Context, logger ports.Logger, w http.ResponseWriter, statusCode int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	if err := json.NewEncoder(w).Encode(APIResponse{
		Success:      false,
		ErrorMessage: message,
	}); err != nil {
		logger.Debug(ctx, err.Error())
	}
}

// MapErrorToResponse safely translates Domain errors into HTTP error responses
func MapErrorToResponse(ctx context.Context, logger ports.Logger, w http.ResponseWriter, err error) {
	switch err {
	case domain.ErrBadRequest:
		Error(ctx, logger, w, http.StatusBadRequest, "BAD_REQUEST")

	case domain.ErrCityNotFound:
		Error(ctx, logger, w, http.StatusNotFound, "CITY_NOT_FOUND")

	case domain.ErrProductNotFound:
		Error(ctx, logger, w, http.StatusNotFound, "PRODUCT_NOT_FOUND")

	default:
		logger.Debug(ctx, "HTTP Error mapper could not map the domain error for http error response", "error", err.Error())
		Error(ctx, logger, w, http.StatusInternalServerError, "INTERNAL_SERVER_ERROR")
	}
}

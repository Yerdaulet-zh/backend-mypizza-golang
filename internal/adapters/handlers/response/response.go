// Package response provides shared utilities for the adapter layer,
// including standardized HTTP response formats and error mapping from domain to http
// to ensure consistent API communication.
package response

import (
	"encoding/json"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
)

// Standart Response Format
type APIResponse struct {
	Success      bool        `json:"success"`
	Data         interface{} `json:"data,omitempty"`
	ErrorMessage string      `json:"error,omitempty"`
}

func Success(w http.ResponseWriter, statusCode int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(APIResponse{
		Success: true,
		Data:    data,
	})
}

func Error(w http.ResponseWriter, statusCode int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	json.NewEncoder(w).Encode(APIResponse{
		Success:      false,
		ErrorMessage: message,
	})
}

// MapErrorToResponse safely translates Domain errors into HTTP responses
func MapErrorToResponse(w http.ResponseWriter, err error) {
	switch err {
	case domain.ErrBadRequest:
		Error(w, http.StatusBadRequest, "BAD_REQUEST")

	case domain.ErrCityNotFound:
		Error(w, http.StatusNotFound, "CITY_NOT_FOUND")

	default:
		Error(w, http.StatusInternalServerError, "INTERNAL_SERVER_ERROR")
	}
}

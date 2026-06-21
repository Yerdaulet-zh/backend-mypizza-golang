package server

import (
	"fmt"
	"net/http"
)

func MapManagementRoutes() http.Handler {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, "Welcome to my secure server!")
	})

	return mux
}

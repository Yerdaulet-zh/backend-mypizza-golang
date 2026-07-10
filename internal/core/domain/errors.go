package domain

import "errors"

var (
	ErrBadRequest          = errors.New("the request payload is malformed or invalid")
	ErrInternalServerError = errors.New("an unexpected error occurred on the server")
	ErrCityNotFound        = errors.New("the specified city does not exist")
	ErrProductNotFound     = errors.New("the product not found")
)

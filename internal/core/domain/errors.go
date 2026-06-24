package domain

import "errors"

var (
	// Initial
	ErrInvalidDSN       = errors.New("invalid DSN provided")
	ErrPostgreSQLOpenDB = errors.New("error while opening a postgresql database")

	// Repository
	ErrDatabaseInternalError = errors.New("database internal error")
)

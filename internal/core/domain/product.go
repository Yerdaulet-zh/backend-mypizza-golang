// Package domain holds
package domain

import (
	"time"

	"github.com/google/uuid"
)

// nolint:govet
type City struct {
	ID   uuid.UUID
	Name string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	Category []Category
}

// nolint:govet
type Category struct {
	ID   uuid.UUID
	Name string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	Products []Product
}

// nolint:govet
type Product struct {
	ID         uuid.UUID
	CategoryID uuid.UUID
	Name       string
	ImageUrl   string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	ProductItems []ProductItem
}

// nolint:govet
type ProductItem struct {
	ID        uuid.UUID
	ProductID uuid.UUID

	Size  *string
	Type  *string
	Count *string

	ImageUrl string
	Price    int64
	Currency string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time
}

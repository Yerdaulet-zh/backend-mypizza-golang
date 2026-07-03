// Package domain holds
package domain

import (
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/persistency/product"
)

// nolint:govet
type City struct {
	ID        uuid.UUID
	Name      string
	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	// Has Many connections to city-specific pricing and availability parameters
	CityCategories   []CityCategory
	CityProducts     []CityProduct
	CityProductItems []CityProductItem
	CityIngredients  []CityIngredient
}

// nolint:govet
type Category struct {
	ID   uuid.UUID
	Name string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	Products       []Product
	CityCategories []CityCategory
}

// nolint:govet
type Product struct {
	ID         uuid.UUID
	CategoryID uuid.UUID
	Name       string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	Category     Category
	ProductItems []ProductItem
	CityProducts []CityProduct
}

// nolint:govet
type ProductItem struct {
	ID        uuid.UUID
	ProductID uuid.UUID

	Size *string
	Type *string

	ImageUrl string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	Product                Product
	ProductItemIngredients []ProductItemIngredient
	CityProductItems       []CityProductItem
}

// nolint:govet
type Ingredient struct {
	ID       uuid.UUID
	Name     string
	ImageUrl string

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt *time.Time

	ProductItemIngredients []ProductItemIngredient
	CityIngredients        []CityIngredient
}

// nolint:govet
type ProductItemIngredient struct {
	ProductItemID uuid.UUID
	IngredientID  uuid.UUID

	IsAvailable  bool
	DisplayOrder int

	CreatedAt time.Time
	UpdatedAt time.Time

	ProductItem ProductItem
	Ingredient  Ingredient
}

// nolint:govet
type CityCategory struct {
	CityID       uuid.UUID
	CategoryID   uuid.UUID
	IsAvailable  bool
	DisplayOrder int

	City     City
	Category Category
}

// nolint:govet
type CityIngredient struct {
	CityID       uuid.UUID
	IngredientID uuid.UUID
	Price        int64
	Currency     product.CurrencyName
	IsAvailable  bool
	UpdatedAt    time.Time

	City       City
	Ingredient Ingredient
}

// nolint:govet
type CityProductItem struct {
	CityID        uuid.UUID
	ProductItemID uuid.UUID
	ProductID     uuid.UUID

	Price       int64
	Currency    product.CurrencyName
	IsAvailable bool
	IsDisplayed bool

	UpdatedAt time.Time

	City        City
	ProductItem ProductItem
}

// nolint:govet
type CityProduct struct {
	CityID       uuid.UUID
	ProductID    uuid.UUID
	IsAvailable  bool
	DisplayOrder int

	UpdatedAt time.Time

	City    City
	Product Product
}

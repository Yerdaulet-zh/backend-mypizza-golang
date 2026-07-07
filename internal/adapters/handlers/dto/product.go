// Package dto will domain related request/response related dto
package dto

import (
	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
)

// START of GetCityAllCategoryProducts

type GetCityAllCategoryProductsRequest struct {
	CityName string `json:"city_name" validate:"required,min=3,max=50"`
}

// nolint:govet
type GetCityAllCategoryProductsResponse struct {
	Categories []CatalogCategory `json:"categories"`
	ID         uuid.UUID         `json:"city_id"`
}

// nolint:govet
type CatalogCategory struct {
	ID           uuid.UUID        `json:"id"`
	Name         string           `json:"name"`
	DisplayOrder int              `json:"display_order"`
	Products     []CatalogProduct `json:"products"`
}

// nolint:govet
type CatalogProduct struct {
	ID           uuid.UUID `json:"id"`
	Name         string    `json:"name"`
	ImageUrl     string    `json:"image_url"`
	Price        int64     `json:"price"`
	Currency     string    `json:"currency"`
	DisplayOrder int       `json:"display_order"`
}

// END of GetCityAllCategoryProducts

// START of catalog product query

type CatalogProductQueryRequest struct {
	CityName    string `json:"city_name" validate:"required,min=3,max=50"`
	ProductName string `json:"name" validate:"required,min=3,max=50"`
}

type CatalogProductQueryResponse struct {
	results []CatalogProductQueryResult
}

type CatalogProductQueryResult struct {
	ProductID   uuid.UUID
	ProductName string
	ImageUrl    string
	Price       int64
	Currency    domain.CurrencyName
}

// END of catalog product query

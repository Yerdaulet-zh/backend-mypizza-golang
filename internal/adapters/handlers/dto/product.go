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
	CityName string `json:"city_name" validate:"required,min=3,max=50"`
	Query    string `json:"query" validate:"required,min=3,max=50"`
}

type CatalogProductQueryResponse struct {
	CityID        uuid.UUID           `json:"city_id"`
	ProductID     uuid.UUID           `json:"product_id"`
	ProductItemID uuid.UUID           `json:"product_item_id"`
	ProductName   string              `json:"product_name"`
	ImageUrl      string              `json:"image_url"`
	Price         int64               `json:"price"`
	Currency      domain.CurrencyName `json:"currency_name"`
}

// END of catalog product query

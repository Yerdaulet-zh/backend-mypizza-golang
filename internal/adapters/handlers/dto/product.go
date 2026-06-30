// Package dto will domain related request/response related dto
package dto

import "github.com/google/uuid"

type GetCityAllCategoryProductsRequest struct {
	CityName string `json:"city_name" validate:"required,min=3,max=50"`
}

type GetCityAllCategoryProductsResponse struct {
	Name     string    `json:"name"`
	ImageUrl string    `json:"image_url"`
	ID       uuid.UUID `json:"id"`
}

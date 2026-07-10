package dproduct

import "github.com/google/uuid"

type ProductCatalogQuerySearchResult struct {
	CityID        uuid.UUID
	ProductID     uuid.UUID
	ProductItemID uuid.UUID
	ProductName   string
	Price         int64
	Currency      string
	Size          string
	Type          string
	ImageURL      string
}

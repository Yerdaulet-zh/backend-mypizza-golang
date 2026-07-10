package repodto

import (
	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain/dproduct"
)

type ProductCatalogQuerySearchResult struct {
	CityID        uuid.UUID `gorm:"type:uuid"`
	ProductID     uuid.UUID `gorm:"type:uuid"`
	ProductItemID uuid.UUID `gorm:"type:uuid"`
	ProductName   string    `gorm:"column:product_name"`
	Price         int64     `gorm:"column:price"`
	Currency      string    `gorm:"column:currency"`
	Size          string    `gorm:"column:size"`
	Type          string    `gorm:"column:type"`
	ImageURL      string    `gorm:"column:image_url"`
}

func (p *ProductCatalogQuerySearchResult) ToDomain() *dproduct.ProductCatalogQuerySearchResult {
	return &dproduct.ProductCatalogQuerySearchResult{
		ProductName:   p.ProductName,
		CityID:        p.CityID,
		ProductID:     p.ProductID,
		ProductItemID: p.ProductItemID,
		Price:         p.Price,
		Currency:      p.Currency,
		Size:          p.Size,
		Type:          p.Type,
		ImageURL:      p.ImageURL,
	}
}

// Package product holds all product related data of MyPizza web app
package product

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"gorm.io/gorm"
)

// nolint:govet
type Product struct {
	ID         uuid.UUID `gorm:"type:uuid;primaryKey"`
	CategoryID uuid.UUID `gorm:"type:uuid;index;not null"`
	Name       string    `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Category     Category      `gorm:"foreignKey:CategoryID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:RESTRICT"`
	ProductItems []ProductItem `gorm:"foreignKey:ProductID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CityProducts []CityProduct `gorm:"foreignKey:ProductID"`
}

func (p *Product) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

func ProductMapper(ctx context.Context, logger ports.Logger, city *City) (map[string]*domain.Product, error) {
	productMap := make(map[string]*domain.Product)
	for _, cityProduct := range city.CityProducts {
		if cityProduct.Product.ID == uuid.Nil {
			logger.Debug(ctx, "CityProduct.Product is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product is missing a city ID value: %s", city.ID.String())
		}
		prod := &domain.Product{
			ID:           cityProduct.ProductID,
			CategoryID:   cityProduct.Product.CategoryID,
			Name:         cityProduct.Product.Name,
			ProductItems: []domain.ProductItem{},
		}
		productMap[prod.ID.String()] = prod
	}
	return productMap, nil
}

func GrouperMappedProductWithMappedProductItem(
	ctx context.Context,
	logger ports.Logger,
	products map[string]*domain.Product,
	productItems map[string]*domain.ProductItem,
) (map[string]*domain.Product, error) {
	for key, item := range productItems {
		prodIDStr := item.ProductID.String()

		prod, exists := products[prodIDStr]
		if !exists {
			// High-value debugging: captures the target product which failed to find, alongside the source item data.
			logger.Debug(ctx, fmt.Sprintf(
				"[Grouper] Mismatch detected: ProductID '%s' (referenced by ProductItemID '%s', map key '%s') does not exist in master product map",
				prodIDStr, item.ID.String(), key,
			))

			return nil, fmt.Errorf(
				"product item relation missing: ProductItemID '%s' references a ProductID '%s' that does not exist",
				item.ID.String(), prodIDStr,
			)
		}

		prod.ProductItems = append(prod.ProductItems, *item)
	}

	return products, nil
}

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
type ProductItem struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductID uuid.UUID `gorm:"type:uuid;index;not null"`

	Size *string `gorm:"type:varchar(50);default:null"`
	Type *string `gorm:"type:varchar(50);default:null"`

	ImageUrl string `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Product                Product                 `gorm:"foreignKey:ProductID;references:ID"`
	ProductItemIngredients []ProductItemIngredient `gorm:"foreignKey:ProductItemID"`
	CityProductItems       []CityProductItem       `gorm:"foreignKey:ProductItemID"`
}

func (p *ProductItem) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

func (p *ProductItem) ToDomain() *domain.ProductItem {
	return &domain.ProductItem{
		ID:                     p.ID,
		ProductID:              p.ProductID,
		Size:                   p.Size,
		Type:                   p.Type,
		ImageUrl:               p.ImageUrl,
		ProductItemIngredients: []domain.ProductItemIngredient{},
		CityProductItems:       []domain.CityProductItem{},
	}
}

func ProductItemMapper(ctx context.Context, logger ports.Logger, city *City) (map[string]*domain.ProductItem, error) {
	productItemMap := make(map[string]*domain.ProductItem)
	for _, cityProductItem := range city.CityProductItems {
		if cityProductItem.ProductItem.ID == uuid.Nil {
			logger.Debug(ctx, "CityProductItem.ProductItem is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product item is missing a city ID value: %s", city.ID.String())
		}
		prodItem := cityProductItem.ProductItem.ToDomain()

		productItemMap[prodItem.ID.String()] = prodItem
	}
	return productItemMap, nil
}

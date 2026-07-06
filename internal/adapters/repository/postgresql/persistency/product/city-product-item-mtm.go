package product

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

// nolint:govet
type CityProductItem struct {
	CityID        uuid.UUID `gorm:"type:uuid;primaryKey;uniqueIndex:idx_one_displayed_item_per_product_per_city,where:is_displayed = true"`
	ProductItemID uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductID     uuid.UUID `gorm:"type:uuid;uniqueIndex:idx_one_displayed_item_per_product_per_city,where:is_displayed = true"`

	Price       int64        `gorm:"type:integer;not null"`
	Currency    CurrencyName `gorm:"type:currency_name;not null;default:'KZT'"`
	IsAvailable bool         `gorm:"type:boolean;index;default:true;not null"`
	IsDisplayed bool         `gorm:"type:boolean;index;default:false;not null"`

	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	City        City        `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	ProductItem ProductItem `gorm:"foreignKey:ProductItemID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

func CityProductItemMapper(ctx context.Context, logger ports.Logger, city *City) (map[string]*domain.CityProductItem, error) {
	cityProductItemMap := make(map[string]*domain.CityProductItem)
	for _, cityProductItem := range city.CityProductItems {
		if cityProductItem.ProductItem.ID == uuid.Nil {
			logger.Debug(ctx, "CityProductItem.ProductItem is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product item is missing a city ID value: %s", city.ID.String())
		}
		cityProdItem := &domain.CityProductItem{
			CityID:        cityProductItem.CityID,
			ProductItemID: cityProductItem.ProductItemID,
			ProductID:     cityProductItem.ProductID,
			Price:         cityProductItem.Price,
			Currency:      domain.CurrencyName(cityProductItem.Currency),
			IsAvailable:   cityProductItem.IsAvailable,
			IsDisplayed:   cityProductItem.IsDisplayed,
		}
		cityProductItemMap[cityProdItem.ProductItemID.String()] = cityProdItem
	}
	return cityProductItemMap, nil
}

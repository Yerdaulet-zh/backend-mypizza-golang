package product

import (
	"time"

	"github.com/google/uuid"
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

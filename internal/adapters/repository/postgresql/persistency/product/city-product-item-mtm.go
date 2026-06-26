package product

import (
	"time"

	"github.com/google/uuid"
)

type CityProductItem struct {
	CityID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductItemID uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable   bool      `gorm:"type:boolean;index;default:true;not null"`

	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	City        City        `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	ProductItem ProductItem `gorm:"foreignKey:ProductItemID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

package product

import (
	"time"

	"github.com/google/uuid"
)

// nolint:govet
type ProductItemIngredient struct {
	ProductItemID uuid.UUID `gorm:"type:uuid;primaryKey"`
	IngredientID  uuid.UUID `gorm:"type:uuid;primaryKey;index"`

	IsAvailable  bool `gorm:"type:boolean;default:true;not null;index"`
	DisplayOrder int  `gorm:"type:integer;default:999;not null;index"`

	CreatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	ProductItem ProductItem `gorm:"foreignKey:ProductItemID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Ingredient  Ingredient  `gorm:"foreignKey:IngredientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

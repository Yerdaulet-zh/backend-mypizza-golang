package product

import (
	"time"

	"github.com/google/uuid"
)

type ProductItemIngredient struct {
	ProductItemID uuid.UUID `gorm:"type:uuid;primaryKey;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:ProductItemID;references:ID"`
	IngredientID  uuid.UUID `gorm:"type:uuid;primaryKey;index;constraint:OnUpdate:CASCADE,OnDelete:CASCADE;foreignKey:IngredientID;references:ID"`
	CreatedAt     time.Time `gorm:"type:timestamptz;default:now();not null"`
}

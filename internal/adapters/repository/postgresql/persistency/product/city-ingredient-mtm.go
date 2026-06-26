package product

import (
	"time"

	"github.com/google/uuid"
)

type CityIngredient struct {
	CityID       uuid.UUID `gorm:"type:uuid;primaryKey"`
	IngredientID uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable  bool      `gorm:"type:boolean;index;default:true;not null"`

	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	City       City       `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Ingredient Ingredient `gorm:"foreignKey:IngredientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

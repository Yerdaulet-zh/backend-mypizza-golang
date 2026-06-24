package product

import "github.com/google/uuid"

type ProductIngredient struct {
	ProductID    uuid.UUID `gorm:"type:uuid;primaryKey"`
	IngredientID uuid.UUID `gorm:"type:uuid;primaryKey;index"`
}

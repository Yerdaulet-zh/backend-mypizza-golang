// Package product holds items and ingredients we sell in the MyPizza web app
package product

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// nolint:govet
type Product struct {
	ID         uuid.UUID `gorm:"type:uuid;primaryKey"`
	CategoryID uuid.UUID `gorm:"type:uuid;index;not null"`
	Name       string    `gorm:"type:varchar(255);not null"`
	ImageUrl   string    `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	// One-to-Many Relationship Definitions
	Category Category `gorm:"foreignKey:CategoryID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:RESTRICT"`

	ProductItem []ProductItem `gorm:"foreignKey:ProductID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`

	// Many-to-Many Relationship Definitions
	Ingredients []Ingredient `gorm:"many2many:product_ingredient;foreignKey:ID;joinForeignKey:ProductID;references:ID;joinReferences:IngredientID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

func (p *Product) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

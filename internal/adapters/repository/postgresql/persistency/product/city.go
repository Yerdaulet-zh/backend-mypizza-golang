package product

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// City represents a geographic location where MyPizza operates
// nolint:govet
type City struct {
	ID        uuid.UUID      `gorm:"type:uuid;primaryKey"`
	Name      string         `gorm:"type:varchar(255);not null;uniqueIndex"`
	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	// Has Many connections to city-specific pricing and availability parameters
	CityCategories   []CityCategory    `gorm:"foreignKey:CityID"`
	CityProducts     []CityProduct     `gorm:"foreignKey:CityID"`
	CityProductItems []CityProductItem `gorm:"foreignKey:CityID"`
	CityIngredients  []CityIngredient  `gorm:"foreignKey:CityID"`
}

func (p *City) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

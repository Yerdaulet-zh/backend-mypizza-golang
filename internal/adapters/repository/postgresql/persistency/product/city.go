package product

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// City represents a geographic location where MyPizza operates
type City struct {
	ID        uuid.UUID      `gorm:"type:uuid;primaryKey"`
	Name      string         `gorm:"type:varchar(255);not null;uniqueIndex"`
	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Categories   []Category    `gorm:"many2many:city_category"`
	Products     []Product     `gorm:"many2many:city_product"`
	Ingredients  []Ingredient  `gorm:"many2many:city_ingredient"`
	ProductItems []ProductItem `gorm:"many2many:city_product_item"`
}

func (p *City) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

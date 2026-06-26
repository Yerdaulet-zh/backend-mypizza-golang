package product

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

// nolint:govet
type Ingredient struct {
	ID       uuid.UUID    `gorm:"type:uuid;primaryKey"`
	Name     string       `gorm:"type:varchar(255);not null"`
	ImageUrl string       `gorm:"type:varchar(255);not null"`
	Price    int64        `gorm:"type:integer;not null"`
	Currency CurrencyName `gorm:"type:currency_name;not null;default:'KZT'"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	ProductItems []ProductItem `gorm:"many2many:product_item_ingredient"`
	Cities       []City        `gorm:"many2many:city_ingredient"`
}

func (p *Ingredient) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

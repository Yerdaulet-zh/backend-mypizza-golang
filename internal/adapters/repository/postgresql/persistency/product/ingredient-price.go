package product

import (
	"time"

	"github.com/google/uuid"
	"gorm.io/gorm"
)

type IngredientPrice struct {
	ID           uuid.UUID `gorm:"type:uuid;primaryKey"`
	IngredientID uuid.UUID `gorm:"type:uuid;index;not null"`
	CityID       uuid.UUID `gorm:"type:uuid;index;not null"`
	Size         ItemSize  `gorm:"type:item_size;not null"`

	Price    int64        `gorm:"type:integer;not null"`
	Currency CurrencyName `gorm:"type:currency_name;not null;default:'KZT'"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	City City `gorm:"foreignKey:CityID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

func (p *IngredientPrice) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

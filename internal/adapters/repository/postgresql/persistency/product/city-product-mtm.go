package product

import (
	"time"

	"github.com/google/uuid"
)

// nolint:govet
type CityProduct struct {
	CityID      uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductID   uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable bool      `gorm:"type:boolean;index;default:true;not null"`

	// Higher priority items get lower numbers (e.g., 1, 2, 3...)
	// Setting a default of 999 ensures unprioritized new items automatically drop to the bottom.
	DisplayOrder int `gorm:"type:integer;default:999;not null;index"`

	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	City    City    `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Product Product `gorm:"foreignKey:ProductID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

package product

import (
	"time"

	"github.com/google/uuid"
)

type CityProduct struct {
	CityID      uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductID   uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable bool      `gorm:"type:boolean;index;default:true;not null"`

	UpdatedAt time.Time `gorm:"type:timestamptz;default:now();not null"`

	City    City    `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Product Product `gorm:"foreignKey:ProductID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

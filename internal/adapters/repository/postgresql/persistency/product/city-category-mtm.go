package product

import "github.com/google/uuid"

// nolint:govet
type CityCategory struct {
	CityID       uuid.UUID `gorm:"type:uuid;primaryKey"`
	CategoryID   uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable  bool      `gorm:"type:boolean;index;default:true;not null"`
	DisplayOrder int       `gorm:"type:integer;default:999;not null;index"`

	City     City     `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Category Category `gorm:"foreignKey:CategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

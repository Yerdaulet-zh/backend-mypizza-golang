package product

import (
	"context"
	"fmt"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

// nolint:govet
type CityCategory struct {
	CityID       uuid.UUID `gorm:"type:uuid;primaryKey"`
	CategoryID   uuid.UUID `gorm:"type:uuid;primaryKey"`
	IsAvailable  bool      `gorm:"type:boolean;index;default:true;not null"`
	DisplayOrder int       `gorm:"type:integer;default:999;not null;index"`

	City     City     `gorm:"foreignKey:CityID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Category Category `gorm:"foreignKey:CategoryID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
}

func CityCategorySlicer(ctx context.Context, logger ports.Logger, city *City) ([]domain.CityCategory, error) {
	cityCategoryList := make([]domain.CityCategory, 0, len(city.CityCategories))
	for _, v := range city.CityCategories {
		if v.Category.ID == uuid.Nil {
			logger.Debug(ctx, "CityCategory.Category.ID is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city category is missing a city ID value: %s", city.ID.String())
		}
		cityCat := domain.CityCategory{
			CityID:       v.CityID,
			CategoryID:   v.CategoryID,
			IsAvailable:  v.IsAvailable,
			DisplayOrder: v.DisplayOrder,
		}
		cityCategoryList = append(cityCategoryList, cityCat)
	}
	return cityCategoryList, nil
}

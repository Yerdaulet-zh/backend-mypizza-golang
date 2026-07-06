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

func GrouperSlicedCityCategoryWithMappedCategory(
	ctx context.Context,
	logger ports.Logger,
	categories map[string]*domain.Category,
	cityCategories []domain.CityCategory,
) ([]domain.CityCategory, error) {
	cityCategoryList := make([]domain.CityCategory, 0, len(cityCategories))

	for i, v := range cityCategories {
		// Case 1: Validation failure (Blank Category ID)
		if v.CategoryID == uuid.Nil {
			logger.Debug(ctx, fmt.Sprintf(
				"[Grouper] Validation failed: CityCategory at index %d has a blank/nil CategoryID (CityID: '%s')",
				i, v.CityID.String(),
			))

			return nil, fmt.Errorf(
				"city category validation failed: missing CategoryID for CityID '%s' at slice index %d",
				v.CityID.String(), i,
			)
		}

		catIDStr := v.CategoryID.String()
		cat, exists := categories[catIDStr]

		// Case 2: Missing Relation failure (Not found in map)
		if !exists {
			logger.Debug(ctx, fmt.Sprintf(
				"[Grouper] Mismatch detected: CategoryID '%s' (referenced by CityID '%s' at index %d) does not exist in master category map",
				catIDStr, v.CityID.String(), i,
			))

			return nil, fmt.Errorf(
				"city category relation missing: CityID '%s' references a CategoryID '%s' that does not exist",
				v.CityID.String(), catIDStr,
			)
		}

		// Happy path: Build and append the populated struct
		cityCat := domain.CityCategory{
			CityID:       v.CityID,
			CategoryID:   v.CategoryID,
			IsAvailable:  v.IsAvailable,
			DisplayOrder: v.DisplayOrder,
			Category:     *cat,
		}
		cityCategoryList = append(cityCategoryList, cityCat)
	}

	return cityCategoryList, nil
}

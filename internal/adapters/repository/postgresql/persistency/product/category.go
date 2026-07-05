package product

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"gorm.io/gorm"
)

// nolint:govet
type Category struct {
	ID   uuid.UUID `gorm:"type:uuid;primaryKey"`
	Name string    `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Products       []Product      `gorm:"foreignKey:CategoryID;references:ID"`
	CityCategories []CityCategory `gorm:"foreignKey:CategoryID"`
}

func (p *Category) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

func CategoryMapper(ctx context.Context, logger ports.Logger, city *City) (map[string]*domain.Category, error) {
	categoryMap := make(map[string]*domain.Category)
	for _, cityCategory := range city.CityCategories {
		if cityCategory.Category.ID == uuid.Nil {
			logger.Debug(ctx, "CityCategory.Category is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city category is missing a city ID value: %s", city.ID.String())
		}
		cat := &domain.Category{
			ID:       cityCategory.CategoryID,
			Name:     cityCategory.Category.Name,
			Products: []domain.Product{},
		}
		categoryMap[cat.ID.String()] = cat
	}
	return categoryMap, nil
}

func GrouperCategoryWithProduct(
	ctx context.Context,
	logger ports.Logger,
	products map[string]*domain.Product,
	category map[string]*domain.Category,
) (map[string]*domain.Category, error) {
	for key, prod := range products {
		catIDStr := prod.CategoryID.String()

		cat, exists := category[catIDStr]
		if !exists {
			// High-value debugging: captures the missing Category ID, the Product ID that requested it, and the map loop key.
			logger.Debug(ctx, fmt.Sprintf(
				"[Grouper] Mismatch detected: CategoryID '%s' (requested by ProductID '%s', map key '%s') does not exist in master category map",
				catIDStr, prod.ID.String(), key,
			))

			return nil, fmt.Errorf(
				"category relation missing: ProductID '%s' references a CategoryID '%s' that does not exist",
				prod.ID.String(), catIDStr,
			)
		}
		cat.Products = append(cat.Products, *prod)
	}

	return category, nil
}

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

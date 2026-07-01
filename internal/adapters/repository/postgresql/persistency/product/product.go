// Package product holds all product related data of MyPizza web app
package product

import (
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"gorm.io/gorm"
)

// nolint:govet
type Product struct {
	ID         uuid.UUID `gorm:"type:uuid;primaryKey"`
	CategoryID uuid.UUID `gorm:"type:uuid;index;not null"`
	Name       string    `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Category     Category      `gorm:"foreignKey:CategoryID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:RESTRICT"`
	ProductItems []ProductItem `gorm:"foreignKey:ProductID;references:ID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CityProducts []CityProduct `gorm:"foreignKey:ProductID"`
}

func (p *Product) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

func (p *Product) ToDomain() *domain.Product {
	if p == nil {
		return nil
	}

	var deletedAtPtr *time.Time
	if p.DeletedAt.Valid {
		deletedAtPtr = &p.DeletedAt.Time
	}

	return &domain.Product{
		ID:         p.ID,
		CategoryID: p.CategoryID,
		Name:       p.Name,
		CreatedAt:  p.CreatedAt,
		UpdatedAt:  p.UpdatedAt,
		DeletedAt:  deletedAtPtr,
	}
}

func ToDomainSlice(dbProducts []Product) []*domain.Product {
	domainProducts := make([]*domain.Product, len(dbProducts))
	for i, p := range dbProducts {
		domainProducts[i] = (&p).ToDomain()
	}
	return domainProducts
}

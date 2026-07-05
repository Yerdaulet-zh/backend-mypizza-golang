package product

import (
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"gorm.io/gorm"
)

// nolint:govet
type ProductItem struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	ProductID uuid.UUID `gorm:"type:uuid;index;not null"`

	Size *string `gorm:"type:varchar(50);default:null"`
	Type *string `gorm:"type:varchar(50);default:null"`

	ImageUrl string `gorm:"type:varchar(255);not null"`

	CreatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	UpdatedAt time.Time      `gorm:"type:timestamptz;default:now();not null"`
	DeletedAt gorm.DeletedAt `gorm:"type:timestamptz;index"`

	Product                Product                 `gorm:"foreignKey:ProductID;references:ID"`
	ProductItemIngredients []ProductItemIngredient `gorm:"foreignKey:ProductItemID"`
	CityProductItems       []CityProductItem       `gorm:"foreignKey:ProductItemID"`
}

func (p *ProductItem) BeforeCreate(tx *gorm.DB) error {
	uuid, err := uuid.NewV7()
	if err != nil {
		return err
	}
	p.ID = uuid
	return nil
}

func (p *ProductItem) ToDomain() *domain.ProductItem {
	return &domain.ProductItem{
		ID:                     p.ID,
		ProductID:              p.ProductID,
		Size:                   p.Size,
		Type:                   p.Type,
		ImageUrl:               p.ImageUrl,
		ProductItemIngredients: []domain.ProductItemIngredient{},
		CityProductItems:       []domain.CityProductItem{},
	}
}

package ports

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
)

type ProductService interface {
	GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error)
}

type ProductRepository interface {
	GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error)
}

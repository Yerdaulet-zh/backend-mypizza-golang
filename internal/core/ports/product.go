package ports

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain/dproduct"
)

type ProductService interface {
	GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error)
	CatalogProductQuery(ctx context.Context, cityName string, query string) ([]*dproduct.ProductCatalogQuerySearchResult, error)
}

type ProductRepository interface {
	GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error)
	CatalogProductQuery(ctx context.Context, cityName string, query string) ([]*dproduct.ProductCatalogQuerySearchResult, error)
}

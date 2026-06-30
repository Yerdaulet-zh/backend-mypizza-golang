package ports

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
)

type ProductService interface {
	GetAllProducts(ctx context.Context, cityName string) (*domain.City, error)
}

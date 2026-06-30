package ports

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"gorm.io/gorm"
)

// Database defines the set of methods required for infrastructure
// health checks and connection lifecycle management.
// This interface is used for mocking the postgre.Client
type Database interface {
	Ping(ctx context.Context) error
	Close() error
	GetGormDB() *gorm.DB
}

type ProductRepository interface {
	GetAllProducts(ctx context.Context, cityName string) (*domain.City, error)
}

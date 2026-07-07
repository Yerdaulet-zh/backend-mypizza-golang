// Package service implements the core business logic of the application,
// coordinating domain behaviors and orchestrating data flow between ports.
package service

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"go.opentelemetry.io/otel"
)

type service struct {
	repo   ports.ProductRepository
	logger ports.Logger
}

func NewProductService(repo ports.ProductRepository, logger ports.Logger) ports.ProductService {
	return &service{
		repo:   repo,
		logger: logger,
	}
}

func (s *service) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
	ctx, span := otel.Tracer("service").Start(ctx, "service.GetCityAllCategoriesProducts")
	defer span.End()
	return s.repo.GetCityAllCategoriesProducts(ctx, cityName)
}

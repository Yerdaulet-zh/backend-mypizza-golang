package repo

import (
	"context"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain/dproduct"
)

func (r *cachedProductRepository) CatalogProductQuery(
	ctx context.Context,
	cityName string,
	query string,
) ([]*dproduct.ProductCatalogQuerySearchResult, error) {
	return r.dbRepo.CatalogProductQuery(ctx, cityName, query)
}

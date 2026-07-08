package repo

import (
	"context"

	repodto "github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/repo_dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain/dproduct"
)

func (r *ProductRepository) CatalogProductQuery(ctx context.Context, cityName string, searchTerms string) ([]*dproduct.ProductCatalogQuerySearchResult, error) {
	r.logger.Debug(ctx, "Repo CatalogProductQuery got hit")

	var dbResults []repodto.ProductCatalogQuerySearchResult

	sqlQuery := `
        SELECT
            p.name AS product_name,
            cpi.city_id,
            cpi.product_id,
            cpi.product_item_id,
            cpi.price,
            cpi.currency,
            pi.size,
            pi.type,
            pi.image_url
        FROM city c
        INNER JOIN city_product cp ON c.id = cp.city_id
        INNER JOIN product p ON cp.product_id = p.id
        INNER JOIN product_item pi ON p.id = pi.product_id
        INNER JOIN city_product_item cpi ON pi.id = cpi.product_item_id AND c.id = cpi.city_id
        WHERE c.name = ?
          AND cp.is_available = true
          AND cpi.is_available = true
          AND cpi.is_displayed = true
          AND p.name ILIKE ?
    `

	search := "%" + searchTerms + "%"
	err := r.db.WithContext(ctx).Raw(sqlQuery, cityName, search).Scan(&dbResults).Error
	if err != nil {
		r.logger.Debug(ctx, "Error occurred at CatalogProductQuery: "+err.Error())
		return nil, err
	}

	// Map the slice of dto to domain structures
	domainResults := make([]*dproduct.ProductCatalogQuerySearchResult, len(dbResults))
	for i, row := range dbResults {
		domainResults[i] = row.ToDomain()
	}

	return domainResults, nil
}

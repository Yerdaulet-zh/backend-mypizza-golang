package product

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/response"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"go.opentelemetry.io/otel"
)

type ProductHandler struct {
	logger  ports.Logger
	service ports.ProductService
}

func NewProductHandler(logger ports.Logger, service ports.ProductService) *ProductHandler {
	return &ProductHandler{
		logger:  logger,
		service: service,
	}
}

func (h *ProductHandler) GetCityAllCategoriesProducts(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	ctx, span := otel.Tracer("http-handler").Start(ctx, "GetCityAllCategoriesProducts")
	defer span.End()

	var req dto.GetCityAllCategoryProductsRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "INVALID_JSON_BODY")
		return
	}
	defer func() { _ = r.Body.Close() }()

	if err := handlers.Validate.Struct(req); err != nil {
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "BODY_VALIDATION_FAILED")
		return
	}

	city, err := h.service.GetCityAllCategoriesProducts(ctx, req.CityName)
	if err != nil {
		response.MapErrorToResponse(ctx, h.logger, w, err)
		return
	}

	cityCategoriesProducts := mapDomainCityToDtoResponse(ctx, city)

	response.Success(ctx, h.logger, w, http.StatusOK, cityCategoriesProducts)
}

func mapDomainCityToDtoResponse(ctx context.Context, city *domain.City) *dto.GetCityAllCategoryProductsResponse {
	ctx, span := otel.Tracer("http-handler").Start(ctx, "http-handler.GetCityAllCategoriesProducts.mapDomainCityToDtoResponse")
	defer span.End()

	if city == nil {
		return nil
	}

	dtoCategories := make([]dto.CatalogCategory, 0, len(city.CityCategories))

	// Walk through the fully populated CityCategories tree
	for _, cityCat := range city.CityCategories {

		dtoProducts := make([]dto.CatalogProduct, 0, len(cityCat.Category.Products))

		// Walk through the products pre-grouped by repository
		for idx, domainProd := range cityCat.Category.Products {

			var price int64 = 0
			var currency string = ""
			var imageUrl string = ""

			// Extract item pricing & images safely from the ProductItems array
			if len(domainProd.ProductItems) > 0 {
				firstItem := domainProd.ProductItems[0]
				imageUrl = firstItem.ImageUrl

				// Check if this specific item has a localized city variation configuration override
				if len(firstItem.CityProductItems) > 0 {
					price = firstItem.CityProductItems[0].Price
					currency = string(firstItem.CityProductItems[0].Currency)
				}
			}

			dtoProducts = append(dtoProducts, dto.CatalogProduct{
				ID:           domainProd.ID,
				Name:         domainProd.Name,
				ImageUrl:     imageUrl,
				Price:        price,
				Currency:     currency,
				DisplayOrder: idx + 1, // Because it is ordered by default
			})
		}

		dtoCategories = append(dtoCategories, dto.CatalogCategory{
			ID:           cityCat.CategoryID,
			Name:         cityCat.Category.Name,
			DisplayOrder: cityCat.DisplayOrder,
			Products:     dtoProducts,
		})
	}

	return &dto.GetCityAllCategoryProductsResponse{
		ID:         city.ID,
		Categories: dtoCategories,
	}
}

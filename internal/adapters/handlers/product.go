package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/response"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
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

	var req dto.GetCityAllCategoryProductsRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "INVALID_JSON_BODY")
		return
	}
	defer func() { _ = r.Body.Close() }()

	if err := validate.Struct(req); err != nil {
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "BODY_VALIDATION_FAILED")
		return
	}

	cityCategoriesProducts, err := h.service.GetCityAllCategoriesProducts(ctx, req.CityName)
	if err != nil {
		response.MapErrorToResponse(ctx, h.logger, w, err)
		return
	}

	response.Success(ctx, h.logger, w, http.StatusOK, cityCategoriesProducts)
}

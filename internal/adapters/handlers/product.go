package handlers

import (
	"encoding/json"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/response"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

type ProductHandler struct {
	service ports.ProductService
}

func NewProductHandler(service ports.ProductService) *ProductHandler {
	return &ProductHandler{
		service: service,
	}
}

func (h *ProductHandler) GetCityAllCategoriesProducts(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()

	var req dto.GetCityAllCategoryProductsRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		response.Error(w, http.StatusBadRequest, "INVALID_JSON_BODY")
		return
	}
	defer r.Body.Close()

	if err := validate.Struct(req); err != nil {
		response.Error(w, http.StatusBadRequest, "BODY_VALIDATION_FAILED")
		return
	}

	cityCategoriesProducts, err := h.service.GetCityAllCategoriesProducts(ctx, req.CityName)
	if err != nil {
		response.MapErrorToResponse(w, err)
		return
	}

	response.Success(w, http.StatusOK, cityCategoriesProducts)
}

package product

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/response"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
)

func (h *ProductHandler) CatalogProductQuery(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	h.logger.Debug(ctx, "CatalogProductQuery endpoint was hit!")

	var req dto.CatalogProductQueryRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		h.logger.Debug(ctx, "JSON decode error: "+err.Error())
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "INVALID_JSON_BODY")
		return
	}
	defer func() { _ = r.Body.Close() }()

	if err := handlers.Validate.Struct(req); err != nil {
		h.logger.Debug(ctx, fmt.Sprintf("Validation failed: %v", err))
		response.Error(ctx, h.logger, w, http.StatusBadRequest, "BODY_VALIDATION_FAILED")
		return
	}

	dProducts, err := h.service.CatalogProductQuery(ctx, req.CityName, req.Query)
	if err != nil {
		response.MapErrorToResponse(ctx, h.logger, w, err)
		return
	}

	finalResponse := make([]dto.CatalogProductQueryResponse, 0, len(dProducts))
	for _, item := range dProducts {
		finalResponse = append(finalResponse, dto.CatalogProductQueryResponse{
			CityID:        item.CityID,
			ProductID:     item.ProductID,
			ProductItemID: item.ProductItemID,
			ProductName:   item.ProductName,
			ImageUrl:      item.ImageURL,
			Price:         item.Price,
			Currency:      domain.CurrencyName(item.Currency),
		})
	}

	response.Success(ctx, h.logger, w, http.StatusOK, finalResponse)
}

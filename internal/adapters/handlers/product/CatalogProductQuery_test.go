package product

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/handlers/dto"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain/dproduct"
)

func (m *MockProductService) CatalogProductQuery(
	ctx context.Context,
	cityName string,
	query string,
) ([]*dproduct.ProductCatalogQuerySearchResult, error) {

	args := m.Called(ctx, cityName, query)

	if args.Get(0) == nil {
		return nil, args.Error(1)
	}

	return args.Get(0).([]*dproduct.ProductCatalogQuerySearchResult), args.Error(1)
}

func TestCatalogProductQuery(t *testing.T) {
	logger := logging.NewDefaultLogger("../../../../configs")

	results := []*dproduct.ProductCatalogQuerySearchResult{
		{
			CityID:        uuid.MustParse("019f2ba3-7489-701a-848c-fceb68fa6ce9"),
			ProductID:     uuid.MustParse("019f2ba3-748d-76b5-a3e5-8d8a64a43b82"),
			ProductItemID: uuid.MustParse("019f2ba3-749a-7209-8194-25e5f16011dc"),
			ProductName:   "Пицца Аррива",
			Price:         2500,
			Currency:      "KZT",
			ImageURL:      "http://pizza.png",
		},
	}

	tests := []struct {
		name           string
		body           any
		setupMock      func(*MockProductService)
		expectedStatus int
	}{
		{
			name: "success",
			body: dto.CatalogProductQueryRequest{
				CityName: "Shymkent",
				Query:    "арр",
			},
			setupMock: func(m *MockProductService) {
				m.On(
					"CatalogProductQuery",
					mock.Anything,
					"Shymkent",
					"арр",
				).Return(results, nil)
			},
			expectedStatus: http.StatusOK,
		},
		{
			name: "validation error",
			body: dto.CatalogProductQueryRequest{
				CityName: "",
				Query:    "",
			},
			setupMock:      func(m *MockProductService) {},
			expectedStatus: http.StatusBadRequest,
		},
		{
			name: "service error",
			body: dto.CatalogProductQueryRequest{
				CityName: "Unknown",
				Query:    "pizza",
			},
			setupMock: func(m *MockProductService) {
				m.On(
					"CatalogProductQuery",
					mock.Anything,
					"Unknown",
					"pizza",
				).Return(nil, domain.ErrProductNotFound)
			},
			expectedStatus: http.StatusNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockService := new(MockProductService)
			tt.setupMock(mockService)

			handler := NewProductHandler(logger, mockService)

			body, _ := json.Marshal(tt.body)

			req := httptest.NewRequest(
				http.MethodPost,
				"/v1/city/catalog/product/query",
				bytes.NewBuffer(body),
			)
			req.Header.Set("Content-Type", "application/json")

			w := httptest.NewRecorder()

			handler.CatalogProductQuery(w, req)

			assert.Equal(t, tt.expectedStatus, w.Code)
			mockService.AssertExpectations(t)
		})
	}
}

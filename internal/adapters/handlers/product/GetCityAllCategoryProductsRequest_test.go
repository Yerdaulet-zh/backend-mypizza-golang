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
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

type MockProductService struct {
	mock.Mock
	logger ports.Logger
}

func (m *MockProductService) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
	args := m.Called(ctx, cityName)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.City), args.Error(1)
}

// Table Driven Handler Tests
func TestGetCityAllCategoriesProducts(t *testing.T) {
	cityID := uuid.New()
	catID := uuid.New()
	prodID := uuid.New()

	// Mock valid domain city payload data structure
	mockDomainCity := &domain.City{
		ID: cityID,
		CityCategories: []domain.CityCategory{
			{
				CategoryID:   catID,
				DisplayOrder: 1,
				Category: domain.Category{
					Name: "Pizzas",
					Products: []domain.Product{
						{
							ID:   prodID,
							Name: "Margherita",
							ProductItems: []domain.ProductItem{
								{
									ImageUrl: "http://pizza.png",
									CityProductItems: []domain.CityProductItem{
										{Price: 2200, Currency: "KZT"},
									},
								},
							},
						},
					},
				},
			},
		},
	}
	// Mock logger
	logger := logging.NewDefaultLogger("../../../../configs")

	tests := []struct {
		name           string
		requestBody    any    // Can pass valid struct or broken string configurations
		rawBody        string // For deliberate syntax errors
		setupMock      func(m *MockProductService)
		expectedStatus int
	}{
		{
			name:        "Success - Valid Payload Mapping Flow",
			requestBody: dto.GetCityAllCategoryProductsRequest{CityName: "Shymkent"},
			setupMock: func(m *MockProductService) {
				m.On("GetCityAllCategoriesProducts", mock.Anything, "Shymkent").
					Return(mockDomainCity, nil)
			},
			expectedStatus: http.StatusOK,
		}, {
			name:           "Failure - Invalid JSON Syntax",
			requestBody:    `{"city_name": "broken-syntax"`,
			setupMock:      func(m *MockProductService) {}, // Service should never reached
			expectedStatus: http.StatusBadRequest,
		}, {
			name:           "Failure - Validation Failed (Empty City Name)",
			requestBody:    dto.GetCityAllCategoryProductsRequest{CityName: ""},
			setupMock:      func(m *MockProductService) {},
			expectedStatus: http.StatusBadRequest,
		}, {
			name:        "Failure - Domain Service Errors out",
			requestBody: dto.GetCityAllCategoryProductsRequest{CityName: "UnknownCity"},
			setupMock: func(m *MockProductService) {
				m.On("GetCityAllCategoriesProducts", mock.Anything, "UnknownCity").
					Return(nil, domain.ErrCityNotFound)
			},
			expectedStatus: http.StatusNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockService := new(MockProductService)
			tt.setupMock(mockService)
			handler := NewProductHandler(logger, mockService)

			var bodyBytes []byte
			if tt.rawBody != "" {
				bodyBytes = []byte(tt.rawBody)
			} else {
				var err error
				bodyBytes, err = json.Marshal(tt.requestBody)
				assert.NoError(t, err)
			}

			req := httptest.NewRequest(http.MethodGet, "/v1/city/category/products", bytes.NewBuffer(bodyBytes))
			req.Header.Set("Content-Type", "application/json")
			w := httptest.NewRecorder()

			// Act
			handler.GetCityAllCategoriesProducts(w, req)

			// Assert
			assert.Equal(t, tt.expectedStatus, w.Code)
			mockService.AssertExpectations(t)
		})
	}
}

// Independent Unit Test targeting the private Mapper logic directly
func TestMapDomainCityToDtoResponse(t *testing.T) {
	t.Run("Nil Input Returns Nil", func(t *testing.T) {
		res := mapDomainCityToDtoResponse(nil)
		assert.Nil(t, res)
	})

	t.Run("Successful Mapping Tree Transforms Correctly", func(t *testing.T) {
		cityID := uuid.New()
		catID := uuid.New()
		prodID := uuid.New()

		domainCity := &domain.City{
			ID: cityID,
			CityCategories: []domain.CityCategory{
				{
					CategoryID:   catID,
					DisplayOrder: 5,
					Category: domain.Category{
						Name: "Drinks",
						Products: []domain.Product{
							{
								ID:   prodID,
								Name: "Cola",
								ProductItems: []domain.ProductItem{
									{
										ImageUrl: "http://cola.png",
										CityProductItems: []domain.CityProductItem{
											{Price: 500, Currency: "USD"},
										},
									},
								},
							},
						},
					},
				},
			},
		}

		res := mapDomainCityToDtoResponse(domainCity)

		assert.NotNil(t, res)
		assert.Equal(t, cityID, res.ID)
		assert.Len(t, res.Categories, 1)

		// Assert Category conversion
		assert.Equal(t, catID, res.Categories[0].ID)
		assert.Equal(t, "Drinks", res.Categories[0].Name)
		assert.Equal(t, 5, res.Categories[0].DisplayOrder)

		// Assert Child Product extraction array values
		assert.Len(t, res.Categories[0].Products, 1)
		productDto := res.Categories[0].Products[0]
		assert.Equal(t, prodID, productDto.ID)
		assert.Equal(t, "Cola", productDto.Name)
		assert.Equal(t, "http://cola.png", productDto.ImageUrl)
		assert.Equal(t, int64(500), productDto.Price)
		assert.Equal(t, "USD", productDto.Currency)
		assert.Equal(t, 1, productDto.DisplayOrder) // index + 1 rule check
	})
}

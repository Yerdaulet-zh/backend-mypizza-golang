// Package repo provides the repository layer implementations, handling all
// direct interactions, queries, and data persistence operations with the database.
package repo

import (
	"context"
	"time"

	"github.com/google/uuid"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/persistency/product"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"gorm.io/gorm"
)

type ProductRepository struct {
	db     *gorm.DB
	logger ports.Logger
}

func NewProductRepository(db *gorm.DB, logger ports.Logger) ports.ProductRepository {
	return &ProductRepository{
		db:     db,
		logger: logger,
	}
}

func (r *ProductRepository) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
	var city product.City

	err := r.db.WithContext(ctx).
		Select("id", "name").
		Where("name = ?", cityName).

		// Preload only available CityCategories and their associated Categories
		Preload("CityCategories", func(db *gorm.DB) *gorm.DB {
			return db.Where("is_available = ?", true)
		}).
		Preload("CityCategories.Category", nil).

		// Preload only available CityProducts and their associated Products
		Preload("CityProducts", func(db *gorm.DB) *gorm.DB {
			return db.Where("is_available = ?", true)
		}).
		Preload("CityProducts.Product").

		// Preload ProductItems filtered by City availability and specific fields
		Preload("CityProducts.Product.ProductItems", func(db *gorm.DB) *gorm.DB {
			// Join with CityProductItems to filter by the current city's availability
			return db.Table("product_item").
				Select(
					"product_item.id",
					"product_item.product_id",
					"product_item.image_url",
					"product_item.size",
					"product_item.type",
					"product_item.count",
					"product_item.created_at",
					"product_item.updated_at",
					"product_item.deleted_at",
				).
				Joins("JOIN city_product_item ON city_product_item.product_item_id = product_item.id").
				Where("city_product_item.is_available = ? AND city_product_item.city_id = (SELECT id FROM city WHERE name = ? LIMIT 1)", true, cityName)
		}).

		// Preload the localized pricing from the CityProductItem pivot
		Preload("CityProductItems", func(db *gorm.DB) *gorm.DB {
			return db.Select("city_id", "product_item_id", "price", "currency").Where("is_available = ?", true)
		}).
		Find(&city).Error

	if err != nil {
		return nil, err
	}

	return helperGetCityAllCategoriesProducts(&city)
}

func helperGetCityAllCategoriesProducts(city *product.City) (*domain.City, error) {
	// Create a map of product items by their ID for quick pricing/availability lookups
	cityItemMap := make(map[uuid.UUID]product.CityProductItem)
	for _, cpi := range city.CityProductItems {
		cityItemMap[cpi.ProductItemID] = cpi
	}

	// Process and map Products grouped by Category ID
	// We group them first because GORM fetches products flatly via CityProducts pivot
	categoryProducts := make(map[uuid.UUID][]domain.Product)

	for _, cp := range city.CityProducts {
		dbProd := cp.Product

		// Map nested ProductItems for this product
		var domainItems []domain.ProductItem
		for _, pi := range dbProd.ProductItems {
			// Check if this item actually has city-specific configuration populated
			cityConfig, isConfigured := cityItemMap[pi.ID]
			if !isConfigured {
				continue // Skip if not explicitly available in this city
			}

			var deletedAtPtr *time.Time
			if pi.DeletedAt.Valid {
				deletedAtPtr = &pi.DeletedAt.Time
			}

			domainItems = append(domainItems, domain.ProductItem{
				ID:        pi.ID,
				ProductID: pi.ProductID,
				Size:      pi.Size,
				Type:      pi.Type,
				ImageUrl:  pi.ImageUrl,
				Price:     cityConfig.Price,
				Currency:  string(cityConfig.Currency),
				CreatedAt: pi.CreatedAt,
				UpdatedAt: pi.UpdatedAt,
				DeletedAt: deletedAtPtr,
			})
		}

		// Only add the product if it has items available in this city
		if len(domainItems) > 0 {
			var deletedAtPtr *time.Time
			if dbProd.DeletedAt.Valid {
				deletedAtPtr = &dbProd.DeletedAt.Time
			}

			prod := domain.Product{
				ID:           dbProd.ID,
				CategoryID:   dbProd.CategoryID,
				Name:         dbProd.Name,
				CreatedAt:    dbProd.CreatedAt,
				UpdatedAt:    dbProd.UpdatedAt,
				DeletedAt:    deletedAtPtr,
				ProductItems: domainItems,
			}
			categoryProducts[dbProd.CategoryID] = append(categoryProducts[dbProd.CategoryID], prod)
		}
	}

	// Map Categories and attach their corresponding Products
	var domainCategories []domain.Category
	for _, cc := range city.CityCategories {
		dbCat := cc.Category

		// Fetch products belonging to this specific category context
		prods, hasProducts := categoryProducts[dbCat.ID]
		if !hasProducts {
			continue // Skip empty categories if you don't want them in the response
		}

		var deletedAtPtr *time.Time
		if dbCat.DeletedAt.Valid {
			deletedAtPtr = &dbCat.DeletedAt.Time
		}

		domainCategories = append(domainCategories, domain.Category{
			ID:        dbCat.ID,
			Name:      dbCat.Name,
			CreatedAt: dbCat.CreatedAt,
			UpdatedAt: dbCat.UpdatedAt,
			DeletedAt: deletedAtPtr,
			Products:  prods,
		})
	}

	// Construct final root Domain City structure
	var cityDeletedAtPtr *time.Time
	if city.DeletedAt.Valid {
		cityDeletedAtPtr = &city.DeletedAt.Time
	}

	domainCity := domain.City{
		ID:        city.ID,
		Name:      city.Name,
		CreatedAt: city.CreatedAt,
		UpdatedAt: city.UpdatedAt,
		DeletedAt: cityDeletedAtPtr,
		Category:  domainCategories,
	}
	return &domainCity, nil
}

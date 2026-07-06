// Package repo provides the repository layer implementations, handling all
// direct interactions, queries, and data persistence operations with the database.
package repo

import (
	"context"
	"sort"
	"strconv"

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
		Preload("CityCategories", func(db *gorm.DB) *gorm.DB {
			return db.Select("city_id", "category_id", "is_available", "display_order").
				Where("is_available = ?", true).
				Order("display_order ASC")
		}).
		Preload("CityCategories.Category", func(db *gorm.DB) *gorm.DB {
			return db.Select("id", "name")
		}).
		Preload("CityProducts", func(db *gorm.DB) *gorm.DB {
			return db.Select("city_product.city_id", "city_product.product_id", "city_product.is_available", "city_product.display_order").
				// Inner join with city_product_item is used because of is_displayed column in city_product_item may be false for all product items if so then product should not be included
				Joins("INNER JOIN city_product_item ON city_product_item.product_id = city_product.product_id AND city_product_item.city_id = city_product.city_id").
				Where("city_product.is_available = ?", true).
				Where("city_product_item.is_available = ? AND city_product_item.is_displayed = ?", true, true).
				// Look at all the rows that share the exact same product details, collapse them into a single row, and ignore the differences in the item sizes.
				Group("city_product.city_id, city_product.product_id, city_product.is_available, city_product.display_order").
				Order("city_product.display_order ASC")
		}).
		Preload("CityProducts.Product", func(db *gorm.DB) *gorm.DB {
			return db.Select("id", "category_id", "name")
		}).
		Preload("CityProductItems", func(db *gorm.DB) *gorm.DB {
			return db.Select("city_id", "product_item_id", "product_id", "price", "currency", "is_available", "is_displayed").
				Where("is_available = ? AND is_displayed = ?", true, true)
		}).
		Preload("CityProductItems.ProductItem", func(db *gorm.DB) *gorm.DB {
			return db.Select("id", "product_id", "image_url")
		}).
		Find(&city).Error
	if err != nil {
		r.logger.Debug(ctx, "Error occured at GetCityAllCategoriesProducts: "+err.Error())
		return nil, err
	}

	if city.ID == uuid.Nil {
		return nil, domain.ErrCityNotFound
	}

	// lookup map for product DisplayOrder *before* mapping drops the ordering sequence.
	displayOrderMap := make(map[uuid.UUID]int)
	for _, cp := range city.CityProducts {
		displayOrderMap[cp.ProductID] = cp.DisplayOrder
	}

	slicedCityCategories, err := product.CityCategorySlicer(ctx, r.logger, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at cityCategoryMapper: "+err.Error())
		return nil, err
	}

	mappedCategories, err := product.CategoryMapper(ctx, r.logger, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at categoryMapper: "+err.Error())
		return nil, err
	}

	for _, item := range mappedCategories {
		for _, i := range item.CityCategories {
			r.logger.Info(ctx, "HEEEY: "+strconv.Itoa(i.DisplayOrder))
		}
		break
	}

	mappedProducts, err := product.ProductMapper(ctx, r.logger, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at productMapper: "+err.Error())
		return nil, err
	}

	productItems, err := product.ProductItemMapper(ctx, r.logger, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at productItemMapper: "+err.Error())
		return nil, err
	}

	cityProductItems, err := product.CityProductItemMapper(ctx, r.logger, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at cityProductItemMapper: "+err.Error())
		return nil, err
	}

	// Core Alignment: Grouping structural variants with their localized configurations
	productItems, err = product.GrouperProductItemWithCityProductItem(ctx, r.logger, productItems, cityProductItems)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperProductItemWithCityProductItem: "+err.Error())
		return nil, err
	}

	mappedProducts, err = product.GrouperProductWithProductItem(ctx, r.logger, mappedProducts, productItems)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperProductWithProductItem: "+err.Error())
		return nil, err
	}

	mappedCategories, err = product.GrouperCategoryWithProduct(ctx, r.logger, mappedProducts, mappedCategories)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperCategoryWithProduct: "+err.Error())
		return nil, err
	}

	// Sort each Category's products by CityProduct DisplayOrder
	r.categorySortProducts(mappedCategories, displayOrderMap)

	// slicedCityCategories is a slice, so it preserves the initial order of categories
	slicedCityCategories, err = product.GrouperSlicedCityCategoryWithMappedCategory(ctx, r.logger, mappedCategories, slicedCityCategories)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperCityCategoryWithCategory: "+err.Error())
		return nil, err
	}

	dCity := domain.City{
		ID:             city.ID,
		CityCategories: slicedCityCategories,
	}
	return &dCity, nil
}

func (r *ProductRepository) categorySortProducts(mappedCategories map[string]*domain.Category, displayOrderMap map[uuid.UUID]int) {
	// Explicitly sort Products inside each Category using displayOrderMap
	for _, cat := range mappedCategories {
		sort.Slice(cat.Products, func(i, j int) bool {
			orderI := displayOrderMap[cat.Products[i].ID]
			orderJ := displayOrderMap[cat.Products[j].ID]

			if orderI != orderJ {
				return orderI < orderJ
			}
			return cat.Products[i].Name < cat.Products[j].Name // Fallback alphabetical
		})
	}
}

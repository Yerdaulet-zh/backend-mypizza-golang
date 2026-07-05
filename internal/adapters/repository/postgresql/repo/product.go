// Package repo provides the repository layer implementations, handling all
// direct interactions, queries, and data persistence operations with the database.
package repo

import (
	"context"
	"fmt"
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
			return db.Select("city_id", "product_id", "is_available", "display_order").
				Where("is_available = ?", true).
				Order("display_order ASC")
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

	productItems, err := r.productItemMapper(ctx, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at productItemMapper: "+err.Error())
		return nil, err
	}

	cityProductItems, err := r.cityProductItemMapper(ctx, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at cityProductItemMapper: "+err.Error())
		return nil, err
	}

	// Core Alignment: Grouping structural variants with their localized configurations
	productItems, err = r.grouperProductItemWithCityProductItem(ctx, productItems, cityProductItems)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperProductItemWithCityProductItem: "+err.Error())
		return nil, err
	}

	mappedProducts, err = r.grouperProductWithProductItem(ctx, mappedProducts, productItems)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperProductWithProductItem: "+err.Error())
		return nil, err
	}

	mappedCategories, err = r.grouperCategoryWithProduct(ctx, mappedProducts, mappedCategories)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperCategoryWithProduct: "+err.Error())
		return nil, err
	}

	// Sort each Category's products by CityProduct DisplayOrder
	r.categorySortProducts(mappedCategories, displayOrderMap)

	// slicedCityCategories is a slice, so it preserves the initial order of categories
	slicedCityCategories, err = r.grouperCityCategoryWithCategory(ctx, mappedCategories, slicedCityCategories)
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

func (r *ProductRepository) productItemMapper(ctx context.Context, city *product.City) (map[string]*domain.ProductItem, error) {
	productItemMap := make(map[string]*domain.ProductItem)
	for _, cityProductItem := range city.CityProductItems {
		if cityProductItem.ProductItem.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityProductItem.ProductItem is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product item relation missing for city ID: %s", city.ID.String())
		}
		prodItem := cityProductItem.ProductItem.ToDomain()

		productItemMap[prodItem.ID.String()] = prodItem
	}
	return productItemMap, nil
}

func (r *ProductRepository) cityProductItemMapper(ctx context.Context, city *product.City) (map[string]*domain.CityProductItem, error) {
	cityProductItemMap := make(map[string]*domain.CityProductItem)
	for _, cityProductItem := range city.CityProductItems {
		if cityProductItem.ProductItem.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityProductItem.ProductItem is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product item relation missing for city ID: %s", city.ID.String())
		}
		cityProdItem := &domain.CityProductItem{
			CityID:        cityProductItem.CityID,
			ProductItemID: cityProductItem.ProductItemID,
			ProductID:     cityProductItem.ProductID,
			Price:         cityProductItem.Price,
			Currency:      domain.CurrencyName(cityProductItem.Currency),
			IsAvailable:   cityProductItem.IsAvailable,
			IsDisplayed:   cityProductItem.IsDisplayed,
		}
		cityProductItemMap[cityProdItem.ProductItemID.String()] = cityProdItem
	}
	return cityProductItemMap, nil
}

func (r *ProductRepository) grouperProductItemWithCityProductItem(ctx context.Context, productItems map[string]*domain.ProductItem, cityProductItems map[string]*domain.CityProductItem) (map[string]*domain.ProductItem, error) {
	for _, cityProductItem := range cityProductItems {
		itemKey := cityProductItem.ProductItemID.String()
		if productItem, exists := productItems[itemKey]; exists {
			productItem.CityProductItems = append(productItem.CityProductItems, *cityProductItem)
		} else {
			r.logger.Debug(ctx, "CityProductItem.ProductItemID does not match any ProductItem.ID for city ID: "+cityProductItem.CityID.String())
			return nil, fmt.Errorf("city product item relation missing for city ID: %s", cityProductItem.CityID.String())
		}
	}
	return productItems, nil
}

func (r *ProductRepository) grouperProductWithProductItem(ctx context.Context, products map[string]*domain.Product, productItems map[string]*domain.ProductItem) (map[string]*domain.Product, error) {
	for _, item := range productItems {
		prodIDStr := item.ProductID.String()
		if prod, exists := products[prodIDStr]; exists {
			prod.ProductItems = append(prod.ProductItems, *item)
		} else {
			r.logger.Debug(ctx, "ProductItem.ProductID does not match any Product.ID for product item ID: "+item.ID.String())
			return nil, fmt.Errorf("product item relation missing for product item ID: %s", item.ID.String())
		}
	}
	return products, nil
}

func (r *ProductRepository) grouperCategoryWithProduct(ctx context.Context, products map[string]*domain.Product, category map[string]*domain.Category) (map[string]*domain.Category, error) {
	for _, prod := range products {
		catIDStr := prod.CategoryID.String()
		//  FIX: Lookup using the product's CategoryID string, not the product's own identifier
		if cat, exists := category[catIDStr]; exists {
			category[catIDStr].Products = append(cat.Products, *prod)
		} else {
			r.logger.Debug(ctx, "Category.ID map lookup missing for product's CategoryID: "+catIDStr)
			return nil, fmt.Errorf("category relation missing for category ID: %s", catIDStr)
		}
	}
	return category, nil
}

func (r *ProductRepository) grouperCityCategoryWithCategory(ctx context.Context, categories map[string]*domain.Category, cityCategories []domain.CityCategory) ([]domain.CityCategory, error) {
	cityCategoryList := make([]domain.CityCategory, 0, len(cityCategories))
	for _, v := range cityCategories {
		if v.CategoryID == uuid.Nil {
			r.logger.Debug(ctx, "CityCategory.CategoryID is blank for city ID: "+v.CityID.String())
			return nil, fmt.Errorf("city category relation missing for city ID: %s", v.CityID.String())
		}
		if cat, exists := categories[v.CategoryID.String()]; exists {
			cityCat := domain.CityCategory{
				CityID:       v.CityID,
				CategoryID:   v.CategoryID,
				IsAvailable:  v.IsAvailable,
				DisplayOrder: v.DisplayOrder,
				Category:     *cat,
			}
			cityCategoryList = append(cityCategoryList, cityCat)
		} else {
			r.logger.Debug(ctx, "CityCategory.CategoryID does not match any Category.ID for city ID: "+v.CityID.String())
			continue
		}
	}
	return cityCategoryList, nil
}

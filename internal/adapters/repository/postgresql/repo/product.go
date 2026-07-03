// Package repo provides the repository layer implementations, handling all
// direct interactions, queries, and data persistence operations with the database.
package repo

import (
	"context"
	"fmt"

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
			return db.Select("id", "image_url")
		}).
		Find(&city).Error
	if err != nil {
		r.logger.Debug(ctx, "Error occured at GetCityAllCategoriesProducts: "+err.Error())
		return nil, err
	}

	if city.ID == uuid.Nil {
		return nil, domain.ErrCityNotFound
	}

	mappedCityCategories, err := r.cityCategoryMapper(ctx, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at cityCategoryMapper: "+err.Error())
		return nil, err
	}

	mappedCategories, err := r.categoryMapper(ctx, &city)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at categoryMapper: "+err.Error())
		return nil, err
	}

	mappedProducts, err := r.productMapper(ctx, &city)
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

	// 1. Core Alignment: Grouping structural variants with their localized configurations
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

	mappedCityCategories, err = r.grouperCityCategoryWithCategory(ctx, mappedCategories, mappedCityCategories)
	if err != nil {
		r.logger.Debug(ctx, "Error occured at grouperCityCategoryWithCategory: "+err.Error())
		return nil, err
	}

	return &domain.City{
		ID:             city.ID,
		CityCategories: mappedCityCategories,
	}, nil
}

func (r *ProductRepository) cityCategoryMapper(ctx context.Context, city *product.City) ([]domain.CityCategory, error) {
	cityCategoryList := make([]domain.CityCategory, 0, len(city.CityCategories))
	for _, v := range city.CityCategories {
		if v.Category.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityCategory.Category.ID is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city category relation missing for city ID: %s", city.ID.String())
		}
		cityCat := domain.CityCategory{
			CityID:       v.CityID,
			CategoryID:   v.CategoryID,
			IsAvailable:  v.IsAvailable,
			DisplayOrder: v.DisplayOrder,
		}
		cityCategoryList = append(cityCategoryList, cityCat)
	}
	return cityCategoryList, nil
}

func (r *ProductRepository) categoryMapper(ctx context.Context, city *product.City) (map[string]*domain.Category, error) {
	categoryMap := make(map[string]*domain.Category)
	for _, cityCategory := range city.CityCategories {
		if cityCategory.Category.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityCategory.Category is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city category relation missing for city ID: %s", city.ID.String())
		}
		cat := &domain.Category{
			ID:       cityCategory.CategoryID,
			Name:     cityCategory.Category.Name,
			Products: []domain.Product{},
		}
		categoryMap[cat.ID.String()] = cat
	}
	return categoryMap, nil
}

func (r *ProductRepository) productMapper(ctx context.Context, city *product.City) (map[string]*domain.Product, error) {
	productMap := make(map[string]*domain.Product)
	for _, cityProduct := range city.CityProducts {
		if cityProduct.Product.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityProduct.Product is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product relation missing for city ID: %s", city.ID.String())
		}
		prod := &domain.Product{
			ID:           cityProduct.ProductID,
			CategoryID:   cityProduct.Product.CategoryID,
			Name:         cityProduct.Product.Name,
			ProductItems: []domain.ProductItem{},
		}
		productMap[prod.ID.String()] = prod
	}
	return productMap, nil
}

func (r *ProductRepository) productItemMapper(ctx context.Context, city *product.City) (map[string]*domain.ProductItem, error) {
	productItemMap := make(map[string]*domain.ProductItem)
	for _, cityProductItem := range city.CityProductItems {
		if cityProductItem.ProductItem.ID == uuid.Nil {
			r.logger.Debug(ctx, "CityProductItem.ProductItem is blank for city ID: "+city.ID.String())
			return nil, fmt.Errorf("city product item relation missing for city ID: %s", city.ID.String())
		}
		prodItem := &domain.ProductItem{
			ID:               cityProductItem.ProductItemID, // Map the actual variation variant configuration identifier
			ProductID:        cityProductItem.ProductID,     // Keep track of the parent product context
			Size:             cityProductItem.ProductItem.Size,
			Type:             cityProductItem.ProductItem.Type,
			ImageUrl:         cityProductItem.ProductItem.ImageUrl,
			CityProductItems: []domain.CityProductItem{},
		}
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
		//  FIX: Key by ProductItemID string to stay symmetric with productItemMapper
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

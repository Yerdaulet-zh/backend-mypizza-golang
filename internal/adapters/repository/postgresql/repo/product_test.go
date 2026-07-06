package repo

import (
	"context"
	"log"
	"testing"

	"github.com/google/uuid"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"

	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/config"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/persistency/product"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

type ProductRepoIntegrationTestSuite struct {
	suite.Suite
	db   *gorm.DB
	repo *ProductRepository
}

func loadLogger(configPath string) ports.Logger {
	cfg, err := config.NewLoggingConfig(configPath)
	if err != nil {
		log.Fatalf("Error initializing config: %v", err)
	}
	return logging.NewLogger(cfg)
}

// Runs once at the very beginning
func (s *ProductRepoIntegrationTestSuite) SetupSuite() {
	dsn := "host=localhost user=admin password=password dbname=mypizza_test port=5432 sslmode=disable"
	var err error

	s.db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true, // Guarantees matching singular table names
		},
	})
	if err != nil {
		s.T().Fatalf("Failed to initialize database integration suite: %v", err)
	}

	err = s.db.Exec(`
		DO $$
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'currency_name') THEN
				CREATE TYPE currency_name AS ENUM ('KZT', 'USD', 'EUR');
			END IF;
		END $$;
	`).Error
	if err != nil {
		s.T().Fatalf("Failed to dynamically initialize custom database enum types: %v", err)
	}

	err = s.db.AutoMigrate(
		&product.City{},
		&product.Category{},
		&product.CityCategory{},
		&product.Product{},
		&product.CityProduct{},
		&product.ProductItem{},
		&product.CityProductItem{},
	)
	if err != nil {
		s.T().Fatalf("Failed to execute dynamic schema migration: %v", err)
	}

	s.repo = &ProductRepository{
		db:     s.db,
		logger: loadLogger("../../../../../configs"),
	}
}

// Runs before every individual test case
func (s *ProductRepoIntegrationTestSuite) SetupTest() {
	// Clean up using direct DB execution strings to make sure everything clears instantly
	s.db.Exec("TRUNCATE TABLE city_product_item CASCADE")
	s.db.Exec("TRUNCATE TABLE product_item CASCADE")
	s.db.Exec("TRUNCATE TABLE city_product CASCADE")
	s.db.Exec("TRUNCATE TABLE product CASCADE")
	s.db.Exec("TRUNCATE TABLE city_category CASCADE")
	s.db.Exec("TRUNCATE TABLE category CASCADE")
	s.db.Exec("TRUNCATE TABLE city CASCADE")
}

// Runs once at the very end after all tests finish
func (s *ProductRepoIntegrationTestSuite) TearDownSuite() {
	sqlDB, _ := s.db.DB()
	sqlDB.Close()
}

func (s *ProductRepoIntegrationTestSuite) TestGetCityAllCategoriesProducts_CityNotFound() {
	ctx := context.Background()
	result, err := s.repo.GetCityAllCategoriesProducts(ctx, "NonExistentCity")
	assert.Nil(s.T(), result)
	assert.ErrorIs(s.T(), err, domain.ErrCityNotFound)
}

func (s *ProductRepoIntegrationTestSuite) TestGetCityAllCategoriesProducts_Success() {
	ctx := context.Background()

	// 1. Instantiate the explicit base objects
	city := product.City{
		ID:   uuid.New(),
		Name: "Shymkent",
	}
	category := product.Category{
		ID:   uuid.New(),
		Name: "Pizzas",
	}

	// Save parent records and read their exact database state back instantly
	err := s.db.Create(&city).Error
	require.NoError(s.T(), err, "Failed to seed City base entity")

	err = s.db.Create(&category).Error
	require.NoError(s.T(), err, "Failed to seed Category base entity")

	// 2. Build and seed the linked Category record using references from the created records
	cityCategory := product.CityCategory{
		CityID:       city.ID,
		CategoryID:   category.ID,
		IsAvailable:  true,
		DisplayOrder: 1,
	}
	err = s.db.Create(&cityCategory).Error
	require.NoError(s.T(), err, "Failed to seed CityCategory linkage")

	// 3. --- Active Product Tree ---
	activeProduct := product.Product{
		ID:         uuid.New(),
		CategoryID: category.ID,
		Name:       "Pepperoni",
	}
	err = s.db.Create(&activeProduct).Error
	require.NoError(s.T(), err, "Failed to seed Active Product element")

	err = s.db.Create(&product.CityProduct{
		CityID:       city.ID,
		ProductID:    activeProduct.ID,
		IsAvailable:  true,
		DisplayOrder: 2,
	}).Error
	require.NoError(s.T(), err, "Failed to seed CityProduct map metadata")

	activeItem := product.ProductItem{
		ID:        uuid.New(),
		ProductID: activeProduct.ID,
		ImageUrl:  "http://pep.png",
	}
	err = s.db.Create(&activeItem).Error
	require.NoError(s.T(), err, "Failed to seed ProductItem variant")

	err = s.db.Create(&product.CityProductItem{
		CityID:        city.ID,
		ProductItemID: activeItem.ID,
		ProductID:     activeProduct.ID,
		Price:         2500,
		Currency:      "KZT",
		IsAvailable:   true,
		IsDisplayed:   true,
	}).Error
	require.NoError(s.T(), err, "Failed to seed CityProductItem parameters")

	// 4. --- Hidden Product Tree ---
	hiddenProduct := product.Product{
		ID:         uuid.New(),
		CategoryID: category.ID,
		Name:       "Secret Pizza",
	}
	err = s.db.Create(&hiddenProduct).Error
	require.NoError(s.T(), err, "Failed to seed Hidden Product item")

	err = s.db.Create(&product.CityProduct{
		CityID:       city.ID,
		ProductID:    hiddenProduct.ID,
		IsAvailable:  true,
		DisplayOrder: 1,
	}).Error
	require.NoError(s.T(), err, "Failed to seed Hidden CityProduct map metadata")

	hiddenItem := product.ProductItem{
		ID:        uuid.New(),
		ProductID: hiddenProduct.ID,
		ImageUrl:  "http://secret.png",
	}
	err = s.db.Create(&hiddenItem).Error
	require.NoError(s.T(), err, "Failed to seed Hidden ProductItem variant")

	err = s.db.Create(&product.CityProductItem{
		CityID:        city.ID,
		ProductItemID: hiddenItem.ID,
		ProductID:     hiddenProduct.ID,
		Price:         5000,
		Currency:      "KZT",
		IsAvailable:   true,
		IsDisplayed:   false,
	}).Error
	require.NoError(s.T(), err, "Failed to seed Hidden CityProductItem context rules")

	// 5. Execute Target Production Code
	res, err := s.repo.GetCityAllCategoriesProducts(ctx, "Shymkent")

	// 6. Assertions
	assert.NoError(s.T(), err)
	require.NotNil(s.T(), res)
	assert.Equal(s.T(), city.ID, res.ID)

	assert.Len(s.T(), res.CityCategories, 1)
	targetCategory := res.CityCategories[0]
	assert.Equal(s.T(), category.ID, targetCategory.CategoryID)

	assert.Len(s.T(), targetCategory.Category.Products, 1)

	finalProduct := targetCategory.Category.Products[0]
	assert.Equal(s.T(), activeProduct.ID, finalProduct.ID)
	assert.Equal(s.T(), "Pepperoni", finalProduct.Name)

	assert.Len(s.T(), finalProduct.ProductItems, 1)
	assert.Equal(s.T(), "http://pep.png", finalProduct.ProductItems[0].ImageUrl)
}

func TestProductRepoIntegrationTestSuite(t *testing.T) {
	suite.Run(t, new(ProductRepoIntegrationTestSuite))
}

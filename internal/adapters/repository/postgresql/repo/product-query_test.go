package repo

import (
	"context"
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/persistency/product"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

type CatalogProductQueryIntegrationTestSuite struct {
	suite.Suite
	repo *ProductRepository
	db   *gorm.DB
}

func (c *CatalogProductQueryIntegrationTestSuite) SetupSuite() {
	// Setup DB
	dsn := "host=localhost user=admin password=password dbname=mypizza_test port=5432 sslmode=disable"
	var err error

	c.db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
		},
	})
	if err != nil {
		c.T().Fatalf("Failed to initialize database integration suite: %v", err)
	}

	err = c.db.Exec(`
		DO $$
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'currency_name') THEN
				CREATE TYPE currency_name AS ENUM ('KZT', 'USD', 'EUR');
			END IF;
		END $$;
	`).Error
	if err != nil {
		c.T().Fatalf("Failed to dynamically initialize custom database enum types: %v", err)
	}

	// Install pg_trgm on the clean test DB
	if err := c.db.Exec("CREATE EXTENSION IF NOT EXISTS pg_trgm;").Error; err != nil {
		c.T().Fatalf("failed to create pg_trgm extension: %v", err)
	}

	err = c.db.AutoMigrate(
		&product.City{},
		&product.Product{},
		&product.Category{},
		&product.Ingredient{},
		&product.ProductItem{},

		// Explicit join tables
		&product.CityProduct{},
		&product.CityCategory{},
		&product.CityIngredient{},
		&product.CityProductItem{},
		&product.ProductItemIngredient{},
	)
	if err != nil {
		c.T().Fatalf("Failed to execute dynamic schema migration: %v", err)
	}

	c.repo = &ProductRepository{
		db:     c.db,
		logger: logging.NewDefaultLogger("../../../../../configs"),
	}
}

// Runs before every individual test case
func (c *CatalogProductQueryIntegrationTestSuite) SetupTest() {
	// Clean up using direct DB execution strings to make sure everything clears instantly
	c.db.Exec("TRUNCATE TABLE city_product_item CASCADE")
	c.db.Exec("TRUNCATE TABLE product_item CASCADE")
	c.db.Exec("TRUNCATE TABLE city_product CASCADE")
	c.db.Exec("TRUNCATE TABLE product CASCADE")
	c.db.Exec("TRUNCATE TABLE city_category CASCADE")
	c.db.Exec("TRUNCATE TABLE category CASCADE")
	c.db.Exec("TRUNCATE TABLE city CASCADE")

	// Read and run the seeding script dynamically
	seedFilePath := filepath.Join("..", "seeds", "product", "01_seed.sql")
	query, err := os.ReadFile(seedFilePath)
	if err != nil {
		c.T().Fatalf("Failed to read seed file %s: %v", seedFilePath, err)
	}

	// Execute the entire raw SQL file contents
	err = c.db.Exec(string(query)).Error
	if err != nil {
		c.T().Fatalf("Failed to execute seed SQL script: %v", err)
	}
}

func TestCatalogProductQuerySuite(t *testing.T) {
	suite.Run(t, new(CatalogProductQueryIntegrationTestSuite))
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_PartialMatchSuccess() {
	ctx := context.Background()

	results, err := c.repo.CatalogProductQuery(ctx, "Shymkent", "ям")

	if !assert.NoError(c.T(), err) {
		return
	}

	assert.NotEmpty(c.T(), results)

	for _, r := range results {
		assert.Contains(c.T(), r.ProductName, "ям")
		assert.NotEmpty(c.T(), r.CityID)
		assert.NotEmpty(c.T(), r.ProductID)
		assert.NotEmpty(c.T(), r.ProductItemID)
		assert.NotEmpty(c.T(), r.Currency)
		assert.NotEmpty(c.T(), r.ImageURL)
		assert.Greater(c.T(), r.Price, int64(0))
	}
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_NoMatches() {
	ctx := context.Background()

	results, err := c.repo.CatalogProductQuery(
		ctx,
		"Shymkent",
		"PineappleAnanasPizza",
	)

	if !assert.NoError(c.T(), err) {
		return
	}

	assert.Empty(c.T(), results)
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_InvalidCity() {
	ctx := context.Background()

	results, err := c.repo.CatalogProductQuery(
		ctx,
		"Berlin",
		"ям",
	)

	if !assert.NoError(c.T(), err) {
		return
	}

	assert.Empty(c.T(), results)
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_CaseInsensitiveSearch() {
	ctx := context.Background()

	lower, err := c.repo.CatalogProductQuery(
		ctx,
		"Shymkent",
		"арр",
	)
	if !assert.NoError(c.T(), err) {
		return
	}

	upper, err := c.repo.CatalogProductQuery(
		ctx,
		"Shymkent",
		"АРР",
	)
	if !assert.NoError(c.T(), err) {
		return
	}

	assert.Len(c.T(), upper, len(lower))
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_ResultMapping() {
	ctx := context.Background()

	results, err := c.repo.CatalogProductQuery(ctx, "Shymkent", "ям")

	if !assert.NoError(c.T(), err) {
		return
	}

	if assert.NotEmpty(c.T(), results) {
		r := results[0]

		assert.NotEmpty(c.T(), r.ProductName)
		assert.NotEmpty(c.T(), r.CityID)
		assert.NotEmpty(c.T(), r.ProductID)
		assert.NotEmpty(c.T(), r.ProductItemID)
		assert.NotEmpty(c.T(), r.Currency)
		assert.NotEmpty(c.T(), r.Size)
		assert.NotEmpty(c.T(), r.Type)
		assert.NotEmpty(c.T(), r.ImageURL)
		assert.Greater(c.T(), r.Price, int64(0))
	}
}

func (c *CatalogProductQueryIntegrationTestSuite) TestCatalogProductQuery_Limit() {
	ctx := context.Background()

	results, err := c.repo.CatalogProductQuery(ctx, "Shymkent", "а")

	if !assert.NoError(c.T(), err) {
		return
	}

	assert.Len(c.T(), results, 10)
}

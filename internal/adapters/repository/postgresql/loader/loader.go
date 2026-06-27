// Package main serves as a schema loader for Atlas.
// It uses the Atlas GORM provider to extract the database schema from
// GORM models (persistency structs) and output the equivalent SQL
// statements to stdout, enabling automated database migrations.
package main

import (
	"fmt"
	"io"
	"os"
	"path/filepath"
	"sort"

	"ariga.io/atlas-provider-gorm/gormschema"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/repository/postgresql/persistency/product"

	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

const shemaDir = "./internal/adapters/repository/postgresql/schema/"

func main() {
	config := &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
		},
	}

	// Generate SQL from GORM models
	stmts, err := gormschema.New(
		"postgres",
		gormschema.WithConfig(config),
	).Load(
		&product.City{},
		&product.Product{},
		&product.Category{},
		&product.Ingredient{},
		&product.ProductItem{},
		&product.IngredientPrice{},

		// Explicit join tables
		&product.CityProduct{},
		&product.CityCategory{},
		&product.CityIngredient{},
		&product.CityProductItem{},
		&product.ProductItemIngredient{},
	)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to load gorm schema: %v\n", err)
		os.Exit(1)
	}

	// Static SQL file contents
	if err = writeSQLFiles(os.Stdout); err != nil {
		fmt.Fprintf(os.Stderr, "failed to write raw SQL: %v\n", err)
		os.Exit(1)
	}

	// Gorm structs
	if _, err = io.WriteString(os.Stdout, stmts); err != nil {
		fmt.Fprintf(os.Stderr, "error while writing stmts")
	}
}

func writeSQLFiles(w io.Writer) error {
	entries, err := os.ReadDir(shemaDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "failed to load the schema dir %v\n", err)
		return err
	}

	// Pdqsort (Pattern-Defeating Quicksort) for deterministic order - ascending
	sort.Slice(entries, func(i, j int) bool {
		return entries[i].Name() < entries[j].Name()
	})

	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}

		if filepath.Ext(entry.Name()) != ".sql" {
			continue
		}

		path := filepath.Join(shemaDir, entry.Name())

		b, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("read %s: %w", path, err)
		}

		// Write file contents
		if _, err = w.Write(b); err != nil {
			return err
		}

		// add \n at the end
		if _, err = fmt.Fprintln(w); err != nil {
			return err
		}
	}
	return nil
}

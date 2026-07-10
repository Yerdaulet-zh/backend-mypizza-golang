-- Ensure extension is installed BEFORE building the index
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create index "idx_product_name_trgm" to table: "product"
CREATE INDEX "idx_product_name_trgm" ON "product" USING GIN ("name" gin_trgm_ops);

-- Modify "city_product" table
ALTER TABLE "city_product" ADD COLUMN "display_order" integer NOT NULL DEFAULT 999;
-- Create index "idx_city_product_display_order" to table: "city_product"
CREATE INDEX "idx_city_product_display_order" ON "city_product" ("display_order");

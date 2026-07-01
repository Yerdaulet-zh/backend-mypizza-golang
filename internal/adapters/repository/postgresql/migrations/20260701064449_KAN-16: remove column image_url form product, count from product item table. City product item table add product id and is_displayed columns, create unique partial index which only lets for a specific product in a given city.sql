-- Modify "city_product_item" table
ALTER TABLE "city_product_item" ADD COLUMN "product_id" uuid NULL, ADD COLUMN "is_displayed" boolean NOT NULL DEFAULT false;
-- Create index "idx_city_product_item_is_displayed" to table: "city_product_item"
CREATE INDEX "idx_city_product_item_is_displayed" ON "city_product_item" ("is_displayed");
-- Create index "idx_one_displayed_item_per_product_per_city" to table: "city_product_item"
CREATE UNIQUE INDEX "idx_one_displayed_item_per_product_per_city" ON "city_product_item" ("city_id", "product_id") WHERE (is_displayed = true);
-- Modify "product" table
ALTER TABLE "product" DROP COLUMN "image_url";
-- Modify "product_item" table
ALTER TABLE "product_item" DROP COLUMN "count";

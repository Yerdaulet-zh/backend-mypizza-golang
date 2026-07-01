-- Modify "product_item_ingredient" table
ALTER TABLE "product_item_ingredient" ADD COLUMN "is_available" boolean NOT NULL DEFAULT true, ADD COLUMN "display_order" integer NOT NULL DEFAULT 999;
-- Create index "idx_product_item_ingredient_display_order" to table: "product_item_ingredient"
CREATE INDEX "idx_product_item_ingredient_display_order" ON "product_item_ingredient" ("display_order");
-- Create index "idx_product_item_ingredient_is_available" to table: "product_item_ingredient"
CREATE INDEX "idx_product_item_ingredient_is_available" ON "product_item_ingredient" ("is_available");

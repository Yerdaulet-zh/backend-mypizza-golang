-- Add value to enum type: "item_size"
ALTER TYPE "item_size" ADD VALUE '0.3L';
-- Add value to enum type: "item_size"
ALTER TYPE "item_size" ADD VALUE '0.45L';
-- Add value to enum type: "item_size"
ALTER TYPE "item_size" ADD VALUE '0.5L';
-- Add value to enum type: "item_size"
ALTER TYPE "item_size" ADD VALUE '1L';
-- Modify "product_item" table
ALTER TABLE "product_item" DROP COLUMN "pizza_type", ADD COLUMN "type" character varying(255) NULL DEFAULT NULL::character varying, ADD CONSTRAINT "fk_product_product_item" FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
-- Create index "idx_product_item_product_id" to table: "product_item"
CREATE INDEX "idx_product_item_product_id" ON "product_item" ("product_id");
-- Drop enum type "pizza_type"
DROP TYPE "pizza_type";

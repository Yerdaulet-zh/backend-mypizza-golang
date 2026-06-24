-- Create enum type "item_size"
CREATE TYPE "item_size" AS ENUM ('SMALL', 'MEDIUM', 'LARGE');
-- Create enum type "pizza_type"
CREATE TYPE "pizza_type" AS ENUM ('CLASSIC', 'THIN');
-- Create "product_item" table
CREATE TABLE "product_item" (
  "id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "size" "item_size" NOT NULL,
  "pizza_type" "pizza_type" NOT NULL,
  "price" integer NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id")
);
-- Create index "idx_product_item_deleted_at" to table: "product_item"
CREATE INDEX "idx_product_item_deleted_at" ON "product_item" ("deleted_at");

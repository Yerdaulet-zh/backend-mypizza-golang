-- Create enum type "item_type"
CREATE TYPE "public"."item_type" AS ENUM ('Традиционный', 'Тонкое', 'Маленькая', 'Большая');
-- Modify "ingredient" table
ALTER TABLE "public"."ingredient" DROP COLUMN "price", DROP COLUMN "currency";
-- Create "ingredient_price" table
CREATE TABLE "public"."ingredient_price" (
  "id" uuid NOT NULL,
  "ingredient_id" uuid NOT NULL,
  "city_id" uuid NOT NULL,
  "size" "public"."item_size" NOT NULL,
  "price" integer NOT NULL,
  "currency" "public"."currency_name" NOT NULL DEFAULT 'KZT',
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_ingredient_ingredient_prices" FOREIGN KEY ("ingredient_id") REFERENCES "public"."ingredient" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_ingredient_price_city" FOREIGN KEY ("city_id") REFERENCES "public"."city" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_ingredient_price_city_id" to table: "ingredient_price"
CREATE INDEX "idx_ingredient_price_city_id" ON "public"."ingredient_price" ("city_id");
-- Create index "idx_ingredient_price_deleted_at" to table: "ingredient_price"
CREATE INDEX "idx_ingredient_price_deleted_at" ON "public"."ingredient_price" ("deleted_at");
-- Create index "idx_ingredient_price_ingredient_id" to table: "ingredient_price"
CREATE INDEX "idx_ingredient_price_ingredient_id" ON "public"."ingredient_price" ("ingredient_id");
-- Modify "product_item" table
ALTER TABLE "public"."product_item" ALTER COLUMN "size" DROP NOT NULL, ALTER COLUMN "type" TYPE "public"."item_type" USING CASE WHEN "type" IN ('Традиционный', 'Тонкое', 'Маленькая', 'Большая') THEN "type"::"public"."item_type" ELSE NULL END, ALTER COLUMN "type" DROP DEFAULT, ADD COLUMN "count" character varying(255) NULL DEFAULT NULL::character varying, ADD COLUMN "image_url" character varying(255) NOT NULL;
-- Modify "product_item_ingredient" table
ALTER TABLE "public"."product_item_ingredient" DROP CONSTRAINT "fk_product_item_ingredient_ingredient", DROP CONSTRAINT "fk_product_item_ingredient_product_item", ADD COLUMN "updated_at" timestamptz NOT NULL DEFAULT now(), ADD CONSTRAINT "fk_product_item_ingredient_ingredient" FOREIGN KEY ("ingredient_id") REFERENCES "public"."ingredient" ("id") ON UPDATE CASCADE ON DELETE CASCADE, ADD CONSTRAINT "fk_product_item_ingredient_product_item" FOREIGN KEY ("product_item_id") REFERENCES "public"."product_item" ("id") ON UPDATE CASCADE ON DELETE CASCADE;

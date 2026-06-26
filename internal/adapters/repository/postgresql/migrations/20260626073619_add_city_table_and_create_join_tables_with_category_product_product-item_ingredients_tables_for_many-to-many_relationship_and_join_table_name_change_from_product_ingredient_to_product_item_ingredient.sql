-- Create "city" table
CREATE TABLE "city" (
  "id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id")
);
-- Create index "idx_city_deleted_at" to table: "city"
CREATE INDEX "idx_city_deleted_at" ON "city" ("deleted_at");
-- Create index "idx_city_name" to table: "city"
CREATE UNIQUE INDEX "idx_city_name" ON "city" ("name");
-- Create "city_category" table
CREATE TABLE "city_category" (
  "city_id" uuid NOT NULL,
  "category_id" uuid NOT NULL,
  "is_available" boolean NOT NULL DEFAULT true,
  PRIMARY KEY ("city_id", "category_id"),
  CONSTRAINT "fk_city_category_category" FOREIGN KEY ("category_id") REFERENCES "category" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_city_category_city" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_city_category_is_available" to table: "city_category"
CREATE INDEX "idx_city_category_is_available" ON "city_category" ("is_available");
-- Create "city_ingredient" table
CREATE TABLE "city_ingredient" (
  "city_id" uuid NOT NULL,
  "ingredient_id" uuid NOT NULL,
  "is_available" boolean NOT NULL DEFAULT true,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY ("city_id", "ingredient_id"),
  CONSTRAINT "fk_city_ingredient_city" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_city_ingredient_ingredient" FOREIGN KEY ("ingredient_id") REFERENCES "ingredient" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_city_ingredient_is_available" to table: "city_ingredient"
CREATE INDEX "idx_city_ingredient_is_available" ON "city_ingredient" ("is_available");
-- Create "city_product" table
CREATE TABLE "city_product" (
  "city_id" uuid NOT NULL,
  "product_id" uuid NOT NULL,
  "is_available" boolean NOT NULL DEFAULT true,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY ("city_id", "product_id"),
  CONSTRAINT "fk_city_product_city" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_city_product_product" FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_city_product_is_available" to table: "city_product"
CREATE INDEX "idx_city_product_is_available" ON "city_product" ("is_available");
-- Modify "product_item" table
ALTER TABLE "product_item" DROP CONSTRAINT "fk_product_product_item", ADD CONSTRAINT "fk_product_product_items" FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
-- Create "city_product_item" table
CREATE TABLE "city_product_item" (
  "city_id" uuid NOT NULL,
  "product_item_id" uuid NOT NULL,
  "is_available" boolean NOT NULL DEFAULT true,
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY ("city_id", "product_item_id"),
  CONSTRAINT "fk_city_product_item_city" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_city_product_item_product_item" FOREIGN KEY ("product_item_id") REFERENCES "product_item" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_city_product_item_is_available" to table: "city_product_item"
CREATE INDEX "idx_city_product_item_is_available" ON "city_product_item" ("is_available");
-- Create "product_item_ingredient" table
CREATE TABLE "product_item_ingredient" (
  "product_item_id" uuid NOT NULL,
  "ingredient_id" uuid NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY ("product_item_id", "ingredient_id"),
  CONSTRAINT "fk_product_item_ingredient_ingredient" FOREIGN KEY ("ingredient_id") REFERENCES "ingredient" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "fk_product_item_ingredient_product_item" FOREIGN KEY ("product_item_id") REFERENCES "product_item" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Create index "idx_product_item_ingredient_ingredient_id" to table: "product_item_ingredient"
CREATE INDEX "idx_product_item_ingredient_ingredient_id" ON "product_item_ingredient" ("ingredient_id");
-- Drop "product_ingredient" table
DROP TABLE "product_ingredient";

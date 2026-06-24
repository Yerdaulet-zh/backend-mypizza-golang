-- Create "category" table
CREATE TABLE "category" (
  "id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id")
);
-- Create index "idx_category_deleted_at" to table: "category"
CREATE INDEX "idx_category_deleted_at" ON "category" ("deleted_at");
-- Create "product" table
CREATE TABLE "product" (
  "id" uuid NOT NULL,
  "name" character varying(255) NULL,
  "image_url" character varying(255) NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  "category_id" uuid NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "fk_category_products" FOREIGN KEY ("category_id") REFERENCES "category" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- Create index "idx_product_category_id" to table: "product"
CREATE INDEX "idx_product_category_id" ON "product" ("category_id");
-- Create index "idx_product_deleted_at" to table: "product"
CREATE INDEX "idx_product_deleted_at" ON "product" ("deleted_at");
-- Create "ingredient" table
CREATE TABLE "ingredient" (
  "id" uuid NOT NULL,
  "name" character varying(255) NOT NULL,
  "image_url" character varying(255) NOT NULL,
  "price" integer NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT now(),
  "updated_at" timestamptz NOT NULL DEFAULT now(),
  "deleted_at" timestamptz NULL,
  PRIMARY KEY ("id")
);
-- Create index "idx_ingredient_deleted_at" to table: "ingredient"
CREATE INDEX "idx_ingredient_deleted_at" ON "ingredient" ("deleted_at");
-- Create "product_ingredient" table
CREATE TABLE "product_ingredient" (
  "product_id" uuid NOT NULL,
  "ingredient_id" uuid NOT NULL,
  PRIMARY KEY ("product_id", "ingredient_id"),
  CONSTRAINT "fk_product_ingredient_ingredient" FOREIGN KEY ("ingredient_id") REFERENCES "ingredient" ("id") ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT "fk_product_ingredient_product" FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON UPDATE CASCADE ON DELETE CASCADE
);
-- Create index "idx_product_ingredient_ingredient_id" to table: "product_ingredient"
CREATE INDEX "idx_product_ingredient_ingredient_id" ON "product_ingredient" ("ingredient_id");

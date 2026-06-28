-- Modify "city_category" table
ALTER TABLE "city_category" DROP CONSTRAINT "fk_city_category_category", DROP CONSTRAINT "fk_city_category_city", ADD CONSTRAINT "fk_category_city_categories" FOREIGN KEY ("category_id") REFERENCES "category" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION, ADD CONSTRAINT "fk_city_city_categories" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Modify "city_ingredient" table
ALTER TABLE "city_ingredient" DROP CONSTRAINT "fk_city_ingredient_city", DROP CONSTRAINT "fk_city_ingredient_ingredient", ADD COLUMN "price" integer NOT NULL, ADD COLUMN "currency" "currency_name" NOT NULL DEFAULT 'KZT', ADD CONSTRAINT "fk_city_city_ingredients" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION, ADD CONSTRAINT "fk_ingredient_city_ingredients" FOREIGN KEY ("ingredient_id") REFERENCES "ingredient" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Modify "city_product" table
ALTER TABLE "city_product" DROP CONSTRAINT "fk_city_product_city", DROP CONSTRAINT "fk_city_product_product", ADD CONSTRAINT "fk_city_city_products" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION, ADD CONSTRAINT "fk_product_city_products" FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Modify "product_item" table
ALTER TABLE "product_item" ALTER COLUMN "size" TYPE character varying(50) USING "size"::text, ALTER COLUMN "size" SET DEFAULT NULL::character varying, DROP COLUMN "price", ALTER COLUMN "type" TYPE character varying(50) USING "type"::text, ALTER COLUMN "type" SET DEFAULT NULL::character varying, DROP COLUMN "currency", ALTER COLUMN "count" TYPE character varying(50);
-- Modify "city_product_item" table
ALTER TABLE "city_product_item" DROP CONSTRAINT "fk_city_product_item_city", DROP CONSTRAINT "fk_city_product_item_product_item", ADD COLUMN "price" integer NOT NULL, ADD COLUMN "currency" "currency_name" NOT NULL DEFAULT 'KZT', ADD CONSTRAINT "fk_city_city_product_items" FOREIGN KEY ("city_id") REFERENCES "city" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION, ADD CONSTRAINT "fk_product_item_city_product_items" FOREIGN KEY ("product_item_id") REFERENCES "product_item" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Modify "product_item_ingredient" table
ALTER TABLE "product_item_ingredient" DROP CONSTRAINT "fk_product_item_ingredient_ingredient", DROP CONSTRAINT "fk_product_item_ingredient_product_item", ADD CONSTRAINT "fk_ingredient_product_item_ingredients" FOREIGN KEY ("ingredient_id") REFERENCES "ingredient" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION, ADD CONSTRAINT "fk_product_item_product_item_ingredients" FOREIGN KEY ("product_item_id") REFERENCES "product_item" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION;
-- Drop "ingredient_price" table
DROP TABLE "ingredient_price";
-- Drop enum type "item_size"
DROP TYPE "item_size";
-- Drop enum type "item_type"
DROP TYPE "item_type";

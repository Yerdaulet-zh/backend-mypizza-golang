-- Modify "city_category" table
ALTER TABLE "city_category" ADD COLUMN "display_order" integer NOT NULL DEFAULT 999;
-- Create index "idx_city_category_display_order" to table: "city_category"
CREATE INDEX "idx_city_category_display_order" ON "city_category" ("display_order");

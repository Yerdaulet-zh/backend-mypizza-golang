-- Create enum type "currency_name"
CREATE TYPE "currency_name" AS ENUM ('KZT');
-- Modify "ingredient" table
ALTER TABLE "ingredient" ADD COLUMN "currency" "currency_name" NOT NULL DEFAULT 'KZT';
-- Modify "product_item" table
ALTER TABLE "product_item" ADD COLUMN "currency" "currency_name" NOT NULL DEFAULT 'KZT';

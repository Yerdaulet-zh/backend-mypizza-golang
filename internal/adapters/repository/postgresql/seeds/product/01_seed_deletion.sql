-- ============================================================================
-- BULLETPROOF SEED DATA TRUNCATION SCRIPT
-- ============================================================================

BEGIN;

-- Wipe out junction/intersection tables first (Leaf nodes)
TRUNCATE TABLE city_product_item CASCADE;
TRUNCATE TABLE city_ingredient CASCADE;
TRUNCATE TABLE city_product CASCADE;
TRUNCATE TABLE city_category CASCADE;

-- Wipe out child SKU variations
TRUNCATE TABLE product_item CASCADE;

-- Delete products (Using TRUNCATE with CASCADE forces deletion of anything dependent)
TRUNCATE TABLE product CASCADE;

-- Delete categories safely now that all products are gone
TRUNCATE TABLE category CASCADE;

-- Wipe out tracking/ingredients table
TRUNCATE TABLE ingredient CASCADE;

-- Delete seeded cities
DELETE FROM city WHERE name IN ('Shymkent', 'Almaty', 'Astana');

COMMIT;

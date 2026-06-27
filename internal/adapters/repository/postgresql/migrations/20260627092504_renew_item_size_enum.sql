-- Create the new enum
CREATE TYPE item_size_v2 AS ENUM (
    '20см',
    '25см',
    '30см',
    '35см',
    '0.3L',
    '0.45L',
    '0.5L',
    '1.0L'
);

-- Convert the column
ALTER TABLE product_item
ALTER COLUMN size TYPE item_size_v2
USING (
    CASE size::text
        WHEN 'SMALL' THEN '20см'
        WHEN 'MEDIUM' THEN '25см'
        WHEN 'LARGE' THEN '30см'
        WHEN '0.3L' THEN '0.3L'
        WHEN '0.45L' THEN '0.45L'
        WHEN '0.5L' THEN '0.5L'
        WHEN '1L' THEN '1.0L'
    END
)::item_size_v2;

-- Drop the old enum
DROP TYPE item_size;

-- Rename the new enum
ALTER TYPE item_size_v2 RENAME TO item_size;

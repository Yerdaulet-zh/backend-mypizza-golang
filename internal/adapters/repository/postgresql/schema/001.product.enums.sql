--- The current 20260627115618 state requires to explcitelly define the enums eveb though they're already defined
--- In migrations fodler by atlas migrate new or by integrating with SQL file such as this at composite_schema block in atlas.hcl
--- These enums were defined at migrations files before:
--- currency_name: 20260624151349
--- item_size starts from 20260624141527 and adds additional enums here 20260624144908 and eventually current version 20260627092504
--- item_type: 20260627093239
CREATE TYPE currency_name AS ENUM ('KZT');

-- Deleted by 20260628065336 migration version
-- CREATE TYPE item_size AS ENUM ('20см', '25см', '30см', '35см', '0.3L', '0.45L', '0.5L', '1.0L');
-- CREATE TYPE item_type AS ENUM ('Традиционный', 'Тонкое', 'Маленькая', 'Большая');

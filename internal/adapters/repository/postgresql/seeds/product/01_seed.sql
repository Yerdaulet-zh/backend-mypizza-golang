BEGIN;

-- ============================================================================
-- CREATE TABLES TO STORE IDs FOR CROSS JOINS
-- ============================================================================
CREATE TEMP TABLE temp_cities (id UUID, name VARCHAR);
CREATE TEMP TABLE temp_categories (id UUID, name VARCHAR);
CREATE TEMP TABLE temp_products (id UUID, name VARCHAR);
CREATE TEMP TABLE temp_ingredients (id UUID, name VARCHAR);
CREATE TEMP TABLE temp_items (id UUID, product_id UUID, size VARCHAR, type VARCHAR);

-- ============================================================================
-- INSERT CORE RECORDS & POPULATE TEMP TABLES
-- ============================================================================

-- 1. Cities
WITH inserted_cities AS (
    INSERT INTO city (id, name, created_at, updated_at)
    VALUES
        (uuidv7(), 'Shymkent', now(), now()),
        (uuidv7(), 'Almaty', now(), now()),
        (uuidv7(), 'Astana', now(), now())
    ON CONFLICT (name) DO UPDATE SET updated_at = now()
    RETURNING id, name
)
INSERT INTO temp_cities SELECT id, name FROM inserted_cities;

-- 2. Categories
INSERT INTO category (id, name, created_at, updated_at)
    VALUES
        (uuidv7(), 'Пиццы', now(), now()),
        (uuidv7(), 'Закуски', now(), now()),
        (uuidv7(), 'Коктейли', now(), now()),
        (uuidv7(), 'Кофе', now(), now()),
        (uuidv7(), 'Напитки', now(), now()),
        (uuidv7(), 'Десерты', now(), now()),
        (uuidv7(), 'Соусы', now(), now());
INSERT INTO temp_categories SELECT id, name FROM category;

-- 3. Products
INSERT INTO product (id, category_id, name, created_at, updated_at)
    VALUES
    -- ПИЦЦЫ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Ветчина и грибы', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Пицца Том ям с цыпленком', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Пицца том ям с креветками', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Мясная', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Мясная с цыпленком', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Маргарита с Песто', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Сладкая пицца пирог', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Чоризо фреш', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Сырная', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Охотничья', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Чикен бомбони', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Терияки', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Креветки с песто', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Чикен бургер', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Чилл Грилл', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Ветчина и сыр', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Двойной цыпленок', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Аррива!', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Пиццы'), 'Бургер-пицца', now(), now()),
    -- ЗАКУСКИ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Покет-пицца ветчина и сыр', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Покет-пицца Чилл Грилл', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Покет-пицца чоризо барбекю', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Паста Том ям', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Паста Мясная', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Ланчбокс Охотничий', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Додстер Терияки', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Додстер', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Додстер с ветчиной', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Закуски'), 'Острый Додстер', now(), now()),
    -- КОКТЕЙЛИ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Коктейли'), 'Молочный коктейль Соленая карамель', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Коктейли'), 'Молочный коктейль Фисташка', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Коктейли'), 'Молочный коктейль с печеньем Орео', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Коктейли'), 'Классический молочный коктейль', now(), now()),
    -- КОФЕ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Кофе'), 'Кофе Капучино', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Кофе'), 'Кофе Латте', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Кофе'), 'Кофе Американо', now(), now()),
    -- НАПИТКИ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Морс Вишня', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Морс Клюква', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Морс Черная Смородина', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Coca-Cola', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Coca-Cola Zero', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Fanta', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Sprite', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Fusetea Персик', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Fusetea Манго-Ананас', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Fusetea Манго-Ромашка',now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Сок Piko Апельсин', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Напитки'), 'Сок Piko Персик', now(), now()),
    -- ДЕСЕРТЫ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Яблочный крамбл', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Чизкейк карамельный с арахисом', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Бруслетики', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Рулетики с корицей', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Маффин Три шоколада', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Маффин Соленая карамель', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Чизкейк Нью-Йорк', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Чизкейк Банановый с шоколадным печеньем', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Пончик Три шоколада', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Пончик клубничный', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Сырники', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Десерты'), 'Сырники с малиновым вареньем', now(), now()),
    -- СОУСЫ
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Тысяча островов', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Сырный', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Чесночный', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Барбекю', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Соус Цезарь', now(), now()),
        (uuidv7(), (SELECT id FROM temp_categories WHERE name = 'Соусы'), 'Малиновое варенье', now(), now());
INSERT INTO temp_products SELECT id, name FROM product;

-- Insert Ingredients (Extra toppings or components)
INSERT INTO ingredient (id, name, image_url, created_at, updated_at)
    VALUES
        (uuidv7(), 'Сырный бортик', 'https://media.dodostatic.net/image/r:292x292/01991534ef937626a4cca9f027f99ea3.png', now(), now()),
        (uuidv7(), 'Моцарелла', 'https://media.dodostatic.net/image/r:292x292/0199ae76395f78f09d95f6af3b6d4f8b.png', now(), now()),
        (uuidv7(), 'Сыры чеддер и пармезан', 'https://media.dodostatic.net/image/r:292x292/01991534fc1175cc8fbceffda60604c6.png', now(), now()),
        (uuidv7(), 'Острый перец халапеньо', 'https://media.dodostatic.net/image/r:292x292/01991532c820763a8c4c825a5a40c227.png', now(), now()),
        (uuidv7(), 'Цыпленок', 'https://media.dodostatic.net/image/r:292x292/019915344152716bb2ea308e6e9f60d0.png', now(), now()),
        (uuidv7(), 'Пепперони из цыпленка', 'https://media.dodostatic.net/image/r:292x292/01991532094578d684f9a6554920377e.png', now(), now()),
        (uuidv7(), 'Ветчина из цыпленка', 'https://media.dodostatic.net/image/r:292x292/01991533855772df87ba3c143e2c54e2.png', now(), now()),
        (uuidv7(), 'Шампиньоны', 'https://media.dodostatic.net/image/r:292x292/01991532a3247905a400876549e4e701.png', now(), now()),
        (uuidv7(), 'Маринованные огурчики', 'https://media.dodostatic.net/image/r:292x292/0199153422a573c98283967125aa3c3b.png', now(), now()),
        (uuidv7(), 'Томаты', 'https://media.dodostatic.net/image/r:292x292/019915315c6170e6b2d6b89d908cff7e.png', now(), now()),
        (uuidv7(), 'Острые колбаски', 'https://media.dodostatic.net/image/r:292x292/0199ae760bcb70c4b73a5a37e42f219b.png', now(), now()),
        (uuidv7(), 'Кубики брынзы', 'https://media.dodostatic.net/image/r:292x292/019915314bfe791e8d140f5486950491.png', now(), now()),
        (uuidv7(), 'Сладкий перец', 'https://media.dodostatic.net/image/r:292x292/019915339505783291265a6222b52677.png', now(), now()),
        (uuidv7(), 'Митболы из говядины', 'https://media.dodostatic.net/image/r:292x292/01991532b4ce784a95cb68cefe984490.png', now(), now()),
        (uuidv7(), 'Чеснок', 'https://media.dodostatic.net/image/r:292x292/019a2edc5d887613a19ac0d977a28ab9.png', now(), now()),
        (uuidv7(), 'Красный лук', 'https://media.dodostatic.net/image/r:292x292/0199ae75cd2d7263825feae165d9efdd.png', now(), now()),
        (uuidv7(), 'Итальянские травы', 'https://media.dodostatic.net/image/r:292x292/01991533754f799cbe7c4f89a02bbe56.png', now(), now()),
        (uuidv7(), 'Ананасы', 'https://media.dodostatic.net/image/r:292x292/01991531f6c87608ac218692c725d06d.png', now(), now()),
        -- COFEE
        (uuidv7(), 'Ванильный сироп', 'https://media.dodostatic.net/image/r:292x292/11ee7f0cf561809ea207cf000d289f85.png', now(), now());
INSERT INTO temp_ingredients SELECT id, name FROM ingredient;

-- Insert Product Items (Concrete SKUs with sizes, prices, and enum values)
INSERT INTO product_item (id, product_id, size, type, image_url, created_at, updated_at)
    VALUES
    -- START OF PIZZA PRODUCT ITEM
        -- Ветчина и грибы
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019edfc87364751ab199ed2fe7ced206.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019edfc90c6c766f90aa513f32fb7f22.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019edfca6a9370b98787ade9c962fea5.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019edfcb8dec74939ea3e388af5789f6.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019edfca7c6171ab8a99e98412c75498.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и грибы'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019edfcb979875aca4c32b370aefee90.png', now(), now()),

        -- Пицца Том ям с цыпленком
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e82b2a260717ca56772ba84499b7e.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e82b2ab8e76dca41f3e6a449a6a54.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e82b2c19a721093cc13ab330377dc.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e82b2d9257512ab118ff565c8ec48.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '25см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019e82b2b71a747196b060d0c07de77c.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019e82b2cdd274308ff33937834b86a4.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца Том ям с цыпленком'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019e82b2ef3572b5b44817abe5d11d99.png', now(), now()),

        -- Пицца том ям с креветками
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e829eabf770de97f0328970a2d909.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e829f250577dca2fea2868c8b7695.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e829fefda7725a40f4cadcb7560ac.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e82a036c0795c87444633b97a074d.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '25см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019a7c5a1b4c707099a2162bd3e23cbe.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019e82a022d4746fbaa43f1f36fe2610.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пицца том ям с креветками'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019e82a081bd78d99bdda5461c4a9b53.png', now(), now()),

        -- Мясная
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4807d2c271178830a2f89b5af4ca.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4807dd8c777682d225b9a093bc24.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4807e836717a9cd581aaed1a0790.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4808012a7614ad0a74855509275a.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d4807f43b7695a9c7a6a7be574349.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d48081f057280bec077339bfc3b80.png', now(), now()),

        -- Мясная с цыпленком
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4867ace375a49ac6b498b01fd3d7.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4867b9f475f7936fe5f266a190f3.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4867d1d971f482d52c7a4513a964.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4867f45a734685a69546a368d6ae.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d4867dfc97119b7299a687d2c20e8.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Мясная с цыпленком'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d486803ea774fa70176339792994a.png', now(), now()),

        -- Маргарита с Песто
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d48572a7173cc9cc62f7c73b2e184.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4857333579aaa9315246c053962f.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d485742bd77288f87f77cdab0b347.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019d4857567f72c1be805e5e96254b80.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d48574c43781a8b60c3215b27ddac.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маргарита с Песто'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019d4857620a753caef31f5dba551670.png', now(), now()),

        -- Сладкая пицца пирог
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сладкая пицца пирог'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e8814d0737469b40988e870de40f0.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сладкая пицца пирог'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e8814e1a8788e9ce314473b2c88c0.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сладкая пицца пирог'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019e8814ef5e75169305f0b0f35a5f63.png', now(), now()),

        -- Чоризо фреш
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c42e467714d92f0b4e448f25386.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c42ed0d76358fecb0d3cdc45128.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c42f704740cae3253e3af6994dc.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c43139778dfb8dc5199d294e87c.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c42ffbb730a97faaf88cc957ac9.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чоризо фреш'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c431eb07209ad7bf720062a6206.png', now(), now()),

        -- Сырная
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3aab1573828d80a1ebd4b22f3a.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3ab8fc7184b9f6d46a7aedc32e.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3abfda7669b8fdf577f86b07a9.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3ad5b7765cadcc10d9bfa35cab.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3ac60d72348383c1e9613243d8.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3adbcb79169317f4cbb8ca908f.png', now(), now()),

        -- Чикен бомбони
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019b2193bab7701890ae8d253facb9f8.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019b2193c0b4786d8b688fddde3fa8de.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019b2193cfe073d58444e4cc86ccd998.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019b2193c70f757c867b6b1bb400718e.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырная'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019b2193d55f7239a38e0fed1cf34905.png', now(), now()),

        -- Охотничья
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019c662f3e0b7141bc8706396110f74a.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019c662f4b3674c2bf95f828591b7117.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019c662f56be77088341eb92fc03018c.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019c662fd37b787e9ef36a5cca3312c3.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019c662f76f871caad711b81c8d4d8df.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Охотничья'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019c662fc2487299a08dc86ee26616f7.png', now(), now()),

        -- Терияки
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019a08dc85797832a40793efc5b86b54.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019a08dc8fb079109ca831e6c53c35cf.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019a08dc9ec572a781b0ec251c7cf7e5.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/019a08dcee4f722984f417d68478db5c.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019a08dcda8a729a9a9306be80804de4.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Терияки'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/019a08dcf676792da823e89bd1894dac.png', now(), now()),

        -- Креветки с песто
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c329fa373bc97b9a7eeadd39bf3.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c32a7fc7530896a04b8a151e113.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c32b0c177a48e70902864eef7fe.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c32d0e3727c8978061530c5d68c.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c32b7a47348bffeebca1c9449c4.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Креветки с песто'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c32d8c1747da82ac62ee0fe3c45.png', now(), now()),

        -- Чикен бургер
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c33df1f7514a7f69563d03a7fb8.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c33e536714398ba98bcbe2a4072.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c33ec9b7190911c2a7b133ee389.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c348275799288bcbda93f846946.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c33f43678fd81d670a599c28ed7.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чикен бургер'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c349383736eb0a70ab1a41305b0.png', now(), now()),

        -- Чилл Грилл
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c448b6077a0a838b631d70c3476.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c449546747899044fceecdd51da.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c44a523772c9f60f7fe864fdccc.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c443b8475b5bf8ab227eb8b9014.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c445bfe7051ac26f0f5244f2edc.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чилл Грилл'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c44352075409ac81aa3a4b1cc58.png', now(), now()),

        -- Ветчина и сыр
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3e1221710dbbf15a7b54d79406.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3e1792762ebd250f254eb73313.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3e232d72f99537c7c7dc9cc78c.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3e5f707608ab6e67d8d7a7d63b.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3e282870628749a2c34be89b0f.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ветчина и сыр'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3e4642713bb1ae73bcdb256790.png', now(), now()),

        -- Двойной цыпленок
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3ed44b7957af3c79b60d635d8c.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3ed94d740f9ce6ba3a7a7bcf66.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3ee08e7147b2b1a38bc2f25f39.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3eff2479be9d0799e21afc711f.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3ee93a763499fcfc8f727a675e.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Двойной цыпленок'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3f05f07971b6257b0e46687198.png', now(), now()),

        -- Аррива!
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c36612271c389544ce38db2ac90.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3665607097b2f76f426d0bb1c5.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c366eb7725f91d4efba9c5e5e2f.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c36850a72eca182b26d98912b82.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c367704792b8c114572a60fd78e.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Аррива!'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c368c98753cadf4869a03e8346b.png', now(), now()),

        -- Бургер-пицца
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '20см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3d660b7549a93b8d5f932037c9.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '25см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3d6e9371c4b308165bffefd637.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '30см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3d74bf71d59358fea743d9b27f.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '35см', 'Традиционное', 'https://media.dodostatic.net/image/r:520x520/01995c3da2d070ae954056945b051450.png', now(), now()),

        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '30см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3d8a077170a80b0c96f385c026.png', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бургер-пицца'), '35см', 'Тонкое', 'https://media.dodostatic.net/image/r:520x520/01995c3daa11725eb1bda9de1f9e60c0.png', now(), now()),
    -- END OF PIZZA PRODUCT ITEM

    -- START OF ЗАКУСКИ
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Покет-пицца ветчина и сыр'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019ef2d8bcba70a4a50c15ef19e7ce4f.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Покет-пицца Чилл Грилл'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019ef2cfd4137274b34ae5f6f14d6220.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Покет-пицца чоризо барбекю'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019ef2e12e4978a0830491b11085bc12.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Паста Том ям'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019e827c11897284aab1fd3e0ee972e5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Паста Мясная'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019d4de1f18171b0b1f43658240b818d.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Ланчбокс Охотничий'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019c2f598101772196cd686d206346ee.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Додстер Терияки'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/01989b1249337885aa8967acfb9386af.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Додстер'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/01989b1249337885aa8967acfb9386af.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Додстер с ветчиной'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198eb2de74b731181874e9184cb3b94.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Острый Додстер'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198eb2eb82e75e795f3c3ebbaa0beaf.webp', now(), now()),
    -- END OF ЗАКУСКИ

    -- START OF КОКТЕЙЛИ
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Молочный коктейль Соленая карамель'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/019d3b9469187588a49742adcca90bf5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Молочный коктейль Соленая карамель'), '0.6L', null, 'https://media.dodostatic.net/image/r:584x584/019d3b9479ea78c38c65675fed48de6c.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Молочный коктейль Фисташка'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/019a23c73cbf75b4bf71a6fb15340609.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Молочный коктейль с печеньем Орео'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/019a23c7f60978d186dc1d4a14b607d2.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Классический молочный коктейль'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/019a23c4a4957625a0ac9bf5ad8a8237.webp', now(), now()),
    -- END OF КОКТЕЙЛИ

    -- START OF COFEE
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Кофе Капучино'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/0198ff09ed497723abee3ad26f60801b.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Кофе Капучино'), '0.4L', null, 'https://media.dodostatic.net/image/r:584x584/0198ff097489789283e7a554694df553.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Кофе Латте'), '0.3L', null, 'https://media.dodostatic.net/image/r:584x584/0198ff0831a471059ed1612f33c3c6db.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Кофе Латте'), '0.4L', null, 'https://media.dodostatic.net/image/r:584x584/0198ff083efc76c39a7ef1e76562736f.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Кофе Американо'), '0.4L', null, 'https://media.dodostatic.net/image/r:584x584/019a2f1eff2b787aa3516644c4869552.webp', now(), now()),
    -- END OF COFEE

    -- START OF НАПИТКИ
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Морс Вишня'), '0.45L', null, 'https://media.dodostatic.net/image/r:584x584/0198607dabe979abadbab281afb9ce60.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Морс Клюква'), '0.45L', null, 'https://media.dodostatic.net/image/r:584x584/0198607ddb5778859568b0b329cc4f19.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Морс Черная Смородина'), '0.45L', null, 'https://media.dodostatic.net/image/r:584x584/0198607d7826758f8c72f95e28662da9.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Coca-Cola'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019c1e37841076d4b403e19f95fcf7d5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Coca-Cola'), '1.0L', null, 'https://media.dodostatic.net/image/r:584x584/019c1e3794637663b2d55df3e8d1ac57.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Coca-Cola Zero'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019c1e38e8a972469e31380053ce6df8.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Fanta'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019c1e3967ec72ec96c6295ae704ff34.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Fanta'), '1.0L', null, 'https://media.dodostatic.net/image/r:584x584/019a5d458c5e79c39bbd369808851a89.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Sprite'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019a6d922d8d731d9580d87b3a9d6ca6.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Sprite'), '1.0L', null, 'https://media.dodostatic.net/image/r:584x584/019a5d46b3867740ad810174015878d0.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Fusetea Персик'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019a5d4e2a2d7183b1842b4909576e39.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Fusetea Манго-Ананас'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019aa574fde6740cb07c3d0f2d738618.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Fusetea Манго-Ромашка'), '0.5L', null, 'https://media.dodostatic.net/image/r:584x584/019a5d4d9bc270d0b90b8f8b3d8dac91.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сок Piko Апельсин'), '0.2L', null, 'https://media.dodostatic.net/image/r:584x584/019a6d8f883072d6be4d5e2451a7808b.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сок Piko Апельсин'), '1.0L', null, 'https://media.dodostatic.net/image/r:584x584/019a5d50b0e8715ea62070cdb1706d9a.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сок Piko Персик'), '0.2L', null, 'https://media.dodostatic.net/image/r:584x584/019a6d90078270d4b04319d8c14e32df.webp', now(), now()),
    -- END OF НАПИТКИ

    -- START OF ДЕСЕРТЫ
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Яблочный крамбл'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0199bd2fc16d7291b74a69f9577c0bf2.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чизкейк карамельный с арахисом'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f16a41917609920df1aac36144f6.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бруслетики'), '8шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f16c6d2b79a29cd909844b0b7a59.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Бруслетики'), '16шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f16c72fa753b87aede36fa9c8094.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Рулетики с корицей'), '16шт', null, 'https://media.dodostatic.net/image/r:584x584/01987e8a83a871dfa01fca49070ff9aa.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маффин Три шоколада'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f16fc3bf75d4a64fb5c74f94da86.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Маффин Соленая карамель'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f17015f8730e8ec45b919d59df27.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чизкейк Нью-Йорк'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f16a90a0765eb03e66609842908c.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чизкейк Банановый с шоколадным печеньем'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f169f1a6747db40d0d1fae046c93.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пончик Три шоколада'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019ac60b6dc2770a959f60233829a3ff.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Пончик клубничный'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019ac60b111170f68e05de98dd610b76.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырники'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019a23c11cdb75d6baae6ef67825f654.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырники с малиновым вареньем'), '2шт', null, 'https://media.dodostatic.net/image/r:584x584/0198ff0df6cf7773ad4cf08376763a39.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырники с малиновым вареньем'), '4шт', null, 'https://media.dodostatic.net/image/r:584x584/0198ff0dfc8c7965bd00db456098b891.webp', now(), now()),
    -- END OF ДЕСЕРТЫ

    -- START OF СОУСЫ
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Тысяча островов'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198524091a4771c95824490b4116527.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Сырный'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/01986064cba5781e83bd53806fa54b42.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Чесночный'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/01986065152b78bbbe7c9dbee29700d4.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Барбекю'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/019860646b7a7733b35702260b98d30e.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Соус Цезарь'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/0198f165ec197094b2c93ef185f16cec.webp', now(), now()),
        (uuidv7(), (SELECT id FROM temp_products WHERE name = 'Малиновое варенье'), '1шт', null, 'https://media.dodostatic.net/image/r:584x584/01986063ce9577d3a662add2593c9c86.webp', now(), now());
    -- END OF СОУСЫ
INSERT INTO temp_items SELECT id, product_id, size, type FROM product_item;

-- ============================================================================
-- INTERSECTION SEEDING: MAP PRICES AND VISIBILITY PER CITY
-- ============================================================================

-- Activate Categories in all cities automatically
INSERT INTO city_category (city_id, category_id, is_available)
SELECT c.id, cat.id, true
FROM temp_cities c CROSS JOIN temp_categories cat
ON CONFLICT DO NOTHING;

-- Activate Products in all cities automatically
INSERT INTO city_product (city_id, product_id, is_available, updated_at)
SELECT c.id, p.id, true, now()
FROM temp_cities c CROSS JOIN temp_products p
ON CONFLICT DO NOTHING;

-- Map item pricing definitions to cities explicitly
INSERT INTO city_product_item (city_id, product_item_id, product_id, price, currency, is_available, is_displayed, updated_at)
SELECT
    c.id,
    i.id,
    p.id,
    -- PRICE MAPPING
    CASE
        -- START OF PIZZA - CityProductItem
        -- Ветчина и грибы
        WHEN p.name = 'Ветчина и грибы' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1650
        WHEN p.name = 'Ветчина и грибы' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2350
        WHEN p.name = 'Ветчина и грибы' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Ветчина и грибы' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4190
        WHEN p.name = 'Ветчина и грибы' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Ветчина и грибы' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4190

        -- Пицца Том ям с цыпленком
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1590
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2250
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4250
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '25см' AND i.type = 'Тонкое' THEN 2250
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4250

        -- Пицца том ям с креветками
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1890
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4150
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4990
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '25см' AND i.type = 'Тонкое' THEN 2950
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4150
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4990

        -- Мясная
        WHEN p.name = 'Мясная' AND i.size = '20см' AND i.type = 'Традиционное' THEN 2250
        WHEN p.name = 'Мясная' AND i.size = '25см' AND i.type = 'Традиционное' THEN 3090
        WHEN p.name = 'Мясная' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4750
        WHEN p.name = 'Мясная' AND i.size = '35см' AND i.type = 'Традиционное' THEN 5990
        WHEN p.name = 'Мясная' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4750
        WHEN p.name = 'Мясная' AND i.size = '35см' AND i.type = 'Тонкое' THEN 5990

        -- Мясная с цыпленком
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1590
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2250
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4250
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4250

        -- Маргарита с Песто
        WHEN p.name = 'Маргарита с Песто' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1400
        WHEN p.name = 'Маргарита с Песто' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2090
        WHEN p.name = 'Маргарита с Песто' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3250
        WHEN p.name = 'Маргарита с Песто' AND i.size = '35см' AND i.type = 'Традиционное' THEN 3950
        WHEN p.name = 'Маргарита с Песто' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3250
        WHEN p.name = 'Маргарита с Песто' AND i.size = '35см' AND i.type = 'Тонкое' THEN 3950

        -- Сладкая пицца пирог
        WHEN p.name = 'Сладкая пицца пирог' AND i.size = '25см' AND i.type = 'Традиционное' THEN 1400
        WHEN p.name = 'Сладкая пицца пирог' AND i.size = '30см' AND i.type = 'Традиционное' THEN 1990
        WHEN p.name = 'Сладкая пицца пирог' AND i.size = '35см' AND i.type = 'Традиционное' THEN 2490

        -- Чоризо фреш
        WHEN p.name = 'Чоризо фреш' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1400
        WHEN p.name = 'Чоризо фреш' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2090
        WHEN p.name = 'Чоризо фреш' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3250
        WHEN p.name = 'Чоризо фреш' AND i.size = '35см' AND i.type = 'Традиционное' THEN 3950
        WHEN p.name = 'Чоризо фреш' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3250
        WHEN p.name = 'Чоризо фреш' AND i.size = '35см' AND i.type = 'Тонкое' THEN 3950

        -- Сырная
        WHEN p.name = 'Сырная' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1400
        WHEN p.name = 'Сырная' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2090
        WHEN p.name = 'Сырная' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3250
        WHEN p.name = 'Сырная' AND i.size = '35см' AND i.type = 'Традиционное' THEN 3950
        WHEN p.name = 'Сырная' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3250
        WHEN p.name = 'Сырная' AND i.size = '35см' AND i.type = 'Тонкое' THEN 3950

        -- Чикен бомбони (Fixed: Mapping correctly to 'Чикен бомбони' name instead of 'Сырная')
        WHEN p.name = 'Чикен бомбони' AND i.size = '25см' AND i.type = 'Традиционное' THEN 3090
        WHEN p.name = 'Чикен бомбони' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4750
        WHEN p.name = 'Чикен бомбони' AND i.size = '35см' AND i.type = 'Традиционное' THEN 5990
        WHEN p.name = 'Чикен бомбони' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4750
        WHEN p.name = 'Чикен бомбони' AND i.size = '35см' AND i.type = 'Тонкое' THEN 5990

        -- Охотничья
        WHEN p.name = 'Охотничья' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1890
        WHEN p.name = 'Охотничья' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Охотничья' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4150
        WHEN p.name = 'Охотничья' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4990
        WHEN p.name = 'Охотничья' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4150
        WHEN p.name = 'Охотничья' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4990

        -- Терияки
        WHEN p.name = 'Терияки' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1890
        WHEN p.name = 'Терияки' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Терияки' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4150
        WHEN p.name = 'Терияки' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4990
        WHEN p.name = 'Терияки' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4150
        WHEN p.name = 'Терияки' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4990

        -- Креветки с песто
        WHEN p.name = 'Креветки с песто' AND i.size = '20см' AND i.type = 'Традиционное' THEN 2550
        WHEN p.name = 'Креветки с песто' AND i.size = '25см' AND i.type = 'Традиционное' THEN 3450
        WHEN p.name = 'Креветки с песто' AND i.size = '30см' AND i.type = 'Традиционное' THEN 5050
        WHEN p.name = 'Креветки с песто' AND i.size = '35см' AND i.type = 'Традиционное' THEN 6290
        WHEN p.name = 'Креветки с песто' AND i.size = '30см' AND i.type = 'Тонкое' THEN 5050
        WHEN p.name = 'Креветки с песто' AND i.size = '35см' AND i.type = 'Тонкое' THEN 6290

        -- Чикен бургер
        WHEN p.name = 'Чикен бургер' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1590
        WHEN p.name = 'Чикен бургер' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2250
        WHEN p.name = 'Чикен бургер' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Чикен бургер' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4250
        WHEN p.name = 'Чикен бургер' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Чикен бургер' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4250

        -- Чилл Грилл
        WHEN p.name = 'Чилл Грилл' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1890
        WHEN p.name = 'Чилл Грилл' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Чилл Грилл' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4150
        WHEN p.name = 'Чилл Грилл' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4990
        WHEN p.name = 'Чилл Грилл' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4150
        WHEN p.name = 'Чилл Грилл' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4990

        -- Ветчина и сыр
        WHEN p.name = 'Ветчина и сыр' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1590
        WHEN p.name = 'Ветчина и сыр' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2250
        WHEN p.name = 'Ветчина и сыр' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Ветчина и сыр' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4250
        WHEN p.name = 'Ветчина и сыр' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Ветчина и сыр' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4250

        -- Двойной цыпленок
        WHEN p.name = 'Двойной цыпленок' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1650
        WHEN p.name = 'Двойной цыпленок' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2350
        WHEN p.name = 'Двойной цыпленок' AND i.size = '30см' AND i.type = 'Традиционное' THEN 3650
        WHEN p.name = 'Двойной цыпленок' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4190
        WHEN p.name = 'Двойной цыпленок' AND i.size = '30см' AND i.type = 'Тонкое' THEN 3650
        WHEN p.name = 'Двойной цыпленок' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4190

        -- Аррива!
        WHEN p.name = 'Аррива!' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1890
        WHEN p.name = 'Аррива!' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Аррива!' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4150
        WHEN p.name = 'Аррива!' AND i.size = '35см' AND i.type = 'Традиционное' THEN 4990
        WHEN p.name = 'Аррива!' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4150
        WHEN p.name = 'Аррива!' AND i.size = '35см' AND i.type = 'Тонкое' THEN 4990

        -- Бургер-пицца
        WHEN p.name = 'Бургер-пицца' AND i.size = '20см' AND i.type = 'Традиционное' THEN 1950
        WHEN p.name = 'Бургер-пицца' AND i.size = '25см' AND i.type = 'Традиционное' THEN 2950
        WHEN p.name = 'Бургер-пицца' AND i.size = '30см' AND i.type = 'Традиционное' THEN 4190
        WHEN p.name = 'Бургер-пицца' AND i.size = '35см' AND i.type = 'Традиционное' THEN 5250
        WHEN p.name = 'Бургер-пицца' AND i.size = '30см' AND i.type = 'Тонкое' THEN 4190
        WHEN p.name = 'Бургер-пицца' AND i.size = '35см' AND i.type = 'Тонкое' THEN 5250
        -- END OF PIZZA

        -- START OF ЗАКУСКИ
        WHEN p.name = 'Покет-пицца ветчина и сыр' AND i.size = '1шт' THEN 1650
        WHEN p.name = 'Покет-пицца Чилл Грилл' AND i.size = '1шт' THEN 1650
        WHEN p.name = 'Покет-пицца чоризо барбекю' AND i.size = '1шт' THEN 1650
        WHEN p.name = 'Паста Том ям' AND i.size = '1шт' THEN 2950
        WHEN p.name = 'Паста Мясная' AND i.size = '1шт' THEN 2790
        WHEN p.name = 'Ланчбокс Охотничий' AND i.size = '1шт' THEN 2450
        WHEN p.name = 'Додстер Терияки' AND i.size = '1шт' THEN 1890
        WHEN p.name = 'Додстер' AND i.size = '1шт' THEN 1790
        WHEN p.name = 'Додстер с ветчиной' AND i.size = '1шт' THEN 1550
        WHEN p.name = 'Острый Додстер' AND i.size = '1шт' THEN 1790
        -- END OF ЗАКУСКИ

        -- START OF КОКТЕЙЛИ
        WHEN p.name = 'Молочный коктейль Соленая карамель' AND i.size = '0.3L' THEN 1700
        WHEN p.name = 'Молочный коктейль Соленая карамель' AND i.size = '0.6L' THEN 2550
        WHEN p.name = 'Молочный коктейль Фисташка' AND i.size = '0.3L' THEN 1900
        WHEN p.name = 'Молочный коктейль с печеньем Орео' AND i.size = '0.3L' THEN 1900
        WHEN p.name = 'Классический молочный коктейль' AND i.size = '0.3L' THEN 1500
        -- END OF КОКТЕЙЛИ

        -- START OF COFEE
        WHEN p.name = 'Кофе Капучино' AND i.size = '0.3L' THEN 1050
        WHEN p.name = 'Кофе Капучино' AND i.size = '0.4L' THEN 1150
        WHEN p.name = 'Кофе Латте' AND i.size = '0.3L' THEN 1050
        WHEN p.name = 'Кофе Латте' AND i.size = '0.4L' THEN 1150
        WHEN p.name = 'Кофе Американо' AND i.size = '0.4L' THEN 950
        -- END OF COFEE

        -- START OF НАПИТКИ
        WHEN p.name = 'Морс Вишня' AND i.size = '0.45L' THEN 990
        WHEN p.name = 'Морс Клюква' AND i.size = '0.45L' THEN 990
        WHEN p.name = 'Морс Черная Смородина' AND i.size = '0.45L' THEN 990
        WHEN p.name = 'Coca-Cola' AND i.size = '0.5L' THEN 600
        WHEN p.name = 'Coca-Cola' AND i.size = '1.0L' THEN 900
        WHEN p.name = 'Coca-Cola Zero' AND i.size = '0.5L' THEN 600
        WHEN p.name = 'Fanta' AND i.size = '0.5L' THEN 600
        WHEN p.name = 'Fanta' AND i.size = '1.0L' THEN 900
        WHEN p.name = 'Sprite' AND i.size = '0.5L' THEN 600
        WHEN p.name = 'Sprite' AND i.size = '1.0L' THEN 900
        WHEN p.name = 'Fusetea Персик' AND i.size = '0.5L' THEN 800
        WHEN p.name = 'Fusetea Манго-Ананас' AND i.size = '0.5L' THEN 800
        WHEN p.name = 'Fusetea Манго-Ромашка' AND i.size = '0.5L' THEN 800
        WHEN p.name = 'Сок Piko Апельсин' AND i.size = '0.2L' THEN 550
        WHEN p.name = 'Сок Piko Апельсин' AND i.size = '1.0L' THEN 1700
        WHEN p.name = 'Сок Piko Персик' AND i.size = '0.2L' THEN 550
        -- END OF НАПИТКИ

        -- START OF ДЕСЕРТЫ
        WHEN p.name = 'Яблочный крамбл' AND i.size = '1шт' THEN 1350
        WHEN p.name = 'Чизкейк карамельный с арахисом' AND i.size = '1шт' THEN 1590
        WHEN p.name = 'Бруслетики' AND i.size = '8шт' THEN 950
        WHEN p.name = 'Бруслетики' AND i.size = '16шт' THEN 1250
        WHEN p.name = 'Рулетики с корицей' AND i.size = '16шт' THEN 1050
        WHEN p.name = 'Маффин Три шоколада' AND i.size = '1шт' THEN 850
        WHEN p.name = 'Маффин Соленая карамель' AND i.size = '1шт' THEN 850
        WHEN p.name = 'Чизкейк Нью-Йорк' AND i.size = '1шт' THEN 1590
        WHEN p.name = 'Чизкейк Банановый с шоколадным печеньем' AND i.size = '1шт' THEN 1590
        WHEN p.name = 'Пончик Три шоколада' AND i.size = '1шт' THEN 990
        WHEN p.name = 'Пончик клубничный' AND i.size = '1шт' THEN 990
        WHEN p.name = 'Сырники' AND i.size = '1шт' THEN 1150
        WHEN p.name = 'Сырники с малиновым вареньем' AND i.size = '2шт' THEN 1450
        WHEN p.name = 'Сырники с малиновым вареньем' AND i.size = '4шт' THEN 2350
        -- END OF ДЕСЕРТЫ

        -- START OF СОУСЫ
        WHEN p.name = 'Тысяча островов' AND i.size = '1шт' THEN 400
        WHEN p.name = 'Сырный' AND i.size = '1шт' THEN 400
        WHEN p.name = 'Чесночный' AND i.size = '1шт' THEN 400
        WHEN p.name = 'Барбекю' AND i.size = '1шт' THEN 400
        WHEN p.name = 'Соус Цезарь' AND i.size = '1шт' THEN 400
        WHEN p.name = 'Малиновое варенье' AND i.size = '1шт' THEN 400
        -- END OF СОУСЫ

        ELSE 1 -- Safe fallback price field
    END,
    'KZT',
    true,
    -- DISPLAY MAPPING (Decide exactly which singular row is true)
    CASE
        -- START OF PIZZA DISPLAY SELECTION
        WHEN p.name = 'Ветчина и грибы' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Пицца Том ям с цыпленком' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Пицца том ям с креветками' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Мясная' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Мясная с цыпленком' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Маргарита с Песто' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Сладкая пицца пирог' AND i.size = '25см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Чоризо фреш' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Сырная' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Чикен бомбони' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Охотничья' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Терияки' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Креветки с песто' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Чикен бургер' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Чилл Грилл' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Ветчина и сыр' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Двойной цыпленок' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Аррива!' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        WHEN p.name = 'Бургер-пицца' AND i.size = '30см' AND i.type = 'Традиционное' THEN true
        -- END OF PIZZA DISPLAY SELECTION

        -- ЗАКУСКИ MAPPING
        WHEN p.name = 'Покет-пицца ветчина и сыр' AND i.size = '1шт' THEN true
        WHEN p.name = 'Покет-пицца Чилл Грилл' AND i.size = '1шт' THEN true
        WHEN p.name = 'Покет-пицца чоризо барбекю' AND i.size = '1шт' THEN true
        WHEN p.name = 'Паста Том ям' AND i.size = '1шт' THEN true
        WHEN p.name = 'Паста Мясная' AND i.size = '1шт' THEN true
        WHEN p.name = 'Ланчбокс Охотничий' AND i.size = '1шт' THEN true
        WHEN p.name = 'Додстер Терияки' AND i.size = '1шт' THEN true
        WHEN p.name = 'Додстер' AND i.size = '1шт' THEN true
        WHEN p.name = 'Додстер с ветчиной' AND i.size = '1шт' THEN true
        WHEN p.name = 'Острый Додстер' AND i.size = '1шт' THEN true

        -- КОКТЕЙЛИ MAPPING
        WHEN p.name = 'Молочный коктейль Соленая карамель' AND i.size = '0.3L' THEN true
        WHEN p.name = 'Молочный коктейль Фисташка' AND i.size = '0.3L' THEN true
        WHEN p.name = 'Молочный коктейль с печеньем Орео' AND i.size = '0.3L' THEN true
        WHEN p.name = 'Классический молочный коктейль' AND i.size = '0.3L' THEN true

        -- COFFEE MAPPING
        WHEN p.name = 'Кофе Капучино' AND i.size = '0.3L' THEN true
        WHEN p.name = 'Кофе Латте' AND i.size = '0.3L' THEN true
        WHEN p.name = 'Кофе Американо' AND i.size = '0.4L' THEN true

        -- DRINKS DISPLAY SELECTION
        WHEN p.name = 'Морс Вишня' AND i.size = '0.45L' THEN true
        WHEN p.name = 'Морс Клюква' AND i.size = '0.45L' THEN true
        WHEN p.name = 'Морс Черная Смородина' AND i.size = '0.45L' THEN true
        WHEN p.name = 'Coca-Cola' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Coca-Cola Zero' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Fanta' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Sprite' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Fusetea Персик' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Fusetea Манго-Ананас' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Fusetea Манго-Ромашка' AND i.size = '0.5L' THEN true
        WHEN p.name = 'Сок Piko Апельсин' AND i.size = '0.2L' THEN true
        WHEN p.name = 'Сок Piko Персик' AND i.size = '0.2L' THEN true

        -- DESSERTS DISPLAY SELECTION
        WHEN p.name = 'Яблочный крамбл' AND i.size = '1шт' THEN true
        WHEN p.name = 'Чизкейк карамельный с арахисом' AND i.size = '1шт' THEN true
        WHEN p.name = 'Бруслетики' AND i.size = '8шт' THEN true
        WHEN p.name = 'Рулетики с корицей' AND i.size = '16шт' THEN true
        WHEN p.name = 'Маффин Три шоколада' AND i.size = '1шт' THEN true
        WHEN p.name = 'Маффин Соленая карамель' AND i.size = '1шт' THEN true
        WHEN p.name = 'Чизкейк Нью-Йорк' AND i.size = '1шт' THEN true
        WHEN p.name = 'Чизкейк Банановый с шоколадным печеньем' AND i.size = '1шт' THEN true
        WHEN p.name = 'Пончик Три шоколада' AND i.size = '1шт' THEN true
        WHEN p.name = 'Пончик клубничный' AND i.size = '1шт' THEN true
        WHEN p.name = 'Сырники' AND i.size = '1шт' THEN true
        WHEN p.name = 'Сырники с малиновым вареньем' AND i.size = '2шт' THEN true

        -- СОУСЫ
        WHEN p.name = 'Тысяча островов' AND i.size = '1шт' THEN true
        WHEN p.name = 'Сырный'          AND i.size = '1шт' THEN true
        WHEN p.name = 'Чесночный'       AND i.size = '1шт' THEN true
        WHEN p.name = 'Барбекю'          AND i.size = '1шт' THEN true
        WHEN p.name = 'Соус Цезарь'     AND i.size = '1шт' THEN true
        WHEN p.name = 'Малиновое варенье' AND i.size = '1шт' THEN true

        ELSE false -- Everything else remains hidden on the main grid
    END,
    now()
FROM temp_cities c
CROSS JOIN temp_items i
JOIN product p ON i.product_id = p.id
ON CONFLICT DO NOTHING;

-- Map ingredient pricing updates to cities
INSERT INTO city_ingredient (city_id, ingredient_id, price, currency, is_available, updated_at)
SELECT
    c.id,
    ing.id,
    CASE
        -- PIZZA
        WHEN ing.name = 'Сырный бортик' THEN 10
        WHEN ing.name = 'Моцарелла' THEN 10
        WHEN ing.name = 'Сыры чеддер и пармезан' THEN 10
        WHEN ing.name = 'Острый перец халапеньо' THEN 10
        WHEN ing.name = 'Цыпленок' THEN 10
        WHEN ing.name = 'Пепперони из цыпленка' THEN 10
        WHEN ing.name = 'Ветчина из цыпленка' THEN 10
        WHEN ing.name = 'Шампиньоны' THEN 10
        WHEN ing.name = 'Маринованные огурчики' THEN 10
        WHEN ing.name = 'Томаты' THEN 10
        WHEN ing.name = 'Острые колбаски' THEN 10
        WHEN ing.name = 'Кубики брынзы' THEN 10
        WHEN ing.name = 'Сладкий перец' THEN 10
        WHEN ing.name = 'Митболы из говядины' THEN 10
        WHEN ing.name = 'Чеснок' THEN 10
        WHEN ing.name = 'Красный лук' THEN 10
        WHEN ing.name = 'Итальянские травы' THEN 10
        WHEN ing.name = 'Ананасы' THEN 10

        -- COFEE
        WHEN ing.name = 'Ванильный сироп' THEN 10

        ELSE 300
    END,
    'KZT',
    true,
    now()
FROM temp_cities c CROSS JOIN temp_ingredients ing
ON CONFLICT DO NOTHING;

-- Clean up transactional variables
DROP TABLE temp_cities;
DROP TABLE temp_categories;
DROP TABLE temp_products;
DROP TABLE temp_ingredients;
DROP TABLE temp_items;

COMMIT;

-- ============================================================================
-- INSERT PARENT CORES (Cities, Categories, Ingredients, Products)
-- ============================================================================

-- Insert Cities and capture their IDs
WITH inserted_cities AS (
    INSERT INTO city (id, name, created_at, updated_at)
    VALUES
        (uuidv7(), 'Shymkent', now(), now()),
        (uuidv7(), 'Almaty', now(), now()),
        (uuidv7(), 'Astana', now(), now())
    ON CONFLICT (name) DO NOTHING
    RETURNING id, name
),

-- Insert Categories and capture their IDs
inserted_categories AS (
    INSERT INTO category (id, name, created_at, updated_at)
    VALUES
        (uuidv7(), 'Пиццы', now(), now()),
        (uuidv7(), 'Закуски', now(), now()),
        (uuidv7(), 'Коктейли', now(), now()),
        (uuidv7(), 'Кофе', now(), now()),
        (uuidv7(), 'Напитки', now(), now()),
        (uuidv7(), 'Десерты', now(), now()),
        (uuidv7(), 'Соусы', now(), now())
    ON CONFLICT (name) DO NOTHING
    RETURNING id, name
),

-- Insert Products mapped to the newly created Categories
inserted_products AS (
    INSERT INTO product (id, category_id, name, image_url, created_at, updated_at)
    VALUES
    -- ПИЦЦЫ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Ветчина и грибы', 'https://media.dodostatic.net/image/r:584x584/019edfca6a9370b98787ade9c962fea5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Пицца Том ям с цыпленком', 'https://media.dodostatic.net/image/r:584x584/019e82b2c19a721093cc13ab330377dc.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Пицца том ям с креветками', 'https://media.dodostatic.net/image/r:584x584/019e829fefda7725a40f4cadcb7560ac.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Мясная', 'https://media.dodostatic.net/image/r:584x584/019d4807e836717a9cd581aaed1a0790.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Мясная с цыпленком ', 'https://media.dodostatic.net/image/r:584x584/019d4867d1d971f482d52c7a4513a964.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Маргарита с Песто', 'https://media.dodostatic.net/image/r:584x584/019d485742bd77288f87f77cdab0b347.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Сладкая пицца пирог', 'https://media.dodostatic.net/image/r:584x584/019e8814e1a8788e9ce314473b2c88c0.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Чоризо фреш', 'https://media.dodostatic.net/image/r:584x584/01995c42f704740cae3253e3af6994dc.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Сырная', 'https://media.dodostatic.net/image/r:584x584/01995c3abfda7669b8fdf577f86b07a9.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Охотничья', 'https://media.dodostatic.net/image/r:584x584/019c662f56be77088341eb92fc03018c.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Чикен бомбони', 'https://media.dodostatic.net/image/r:584x584/019b2193c0b4786d8b688fddde3fa8de.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Терияки', 'https://media.dodostatic.net/image/r:584x584/019a08dc9ec572a781b0ec251c7cf7e5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Креветки с песто', 'https://media.dodostatic.net/image/r:584x584/01995c32b0c177a48e70902864eef7fe.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Чикен бургер', 'https://media.dodostatic.net/image/r:584x584/01995c33ec9b7190911c2a7b133ee389.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Чилл Грилл', 'https://media.dodostatic.net/image/r:584x584/01995c44a523772c9f60f7fe864fdccc.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Ветчина и сыр', 'https://media.dodostatic.net/image/r:584x584/01995c3e232d72f99537c7c7dc9cc78c.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Двойной цыпленок', 'https://media.dodostatic.net/image/r:584x584/01995c3ee08e7147b2b1a38bc2f25f39.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Аррива!', 'https://media.dodostatic.net/image/r:584x584/01995c366eb7725f91d4efba9c5e5e2f.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Пиццы'), 'Бургер-пицца', 'https://media.dodostatic.net/image/r:584x584/01995c3d74bf71d59358fea743d9b27f.webp', now(), now())
    -- ЗАКУСКИ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Покет-пицца ветчина и сыр', 'https://media.dodostatic.net/image/r:584x584/019ef2d8bcba70a4a50c15ef19e7ce4f.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Покет-пицца Чилл Грилл', 'https://media.dodostatic.net/image/r:584x584/019ef2cfd4137274b34ae5f6f14d6220.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Покет-пицца чоризо барбекю', 'https://media.dodostatic.net/image/r:584x584/019ef2e12e4978a0830491b11085bc12.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Паста Том ям', 'https://media.dodostatic.net/image/r:584x584/019e827c11897284aab1fd3e0ee972e5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Паста Мясная', 'https://media.dodostatic.net/image/r:584x584/019d4de1f18171b0b1f43658240b818d.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Ланчбокс Охотничий', 'https://media.dodostatic.net/image/r:584x584/019c2f598101772196cd686d206346ee.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Додстер Терияки', 'https://media.dodostatic.net/image/r:584x584/01989b1249337885aa8967acfb9386af.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Додстер', 'https://media.dodostatic.net/image/r:584x584/0198eb2d853f768894e8b9f8e1e2f945.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Додстер с ветчиной', 'https://media.dodostatic.net/image/r:584x584/0198eb2de74b731181874e9184cb3b94.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Закуски'), 'Острый Додстер', 'https://media.dodostatic.net/image/r:584x584/0198eb2eb82e75e795f3c3ebbaa0beaf.webp', now(), now()),
    -- КОКТЕЙЛИ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Коктейли'), 'Молочный коктейль Соленая карамель', 'https://media.dodostatic.net/image/r:584x584/019d3b9469187588a49742adcca90bf5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Коктейли'), 'Молочный коктейль Фисташка', 'https://media.dodostatic.net/image/r:584x584/019a23c73cbf75b4bf71a6fb15340609.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Коктейли'), 'Молочный коктейль с печеньем Орео', 'https://media.dodostatic.net/image/r:584x584/019a23c7f60978d186dc1d4a14b607d2.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Коктейли'), 'Классический молочный коктейль', 'https://media.dodostatic.net/image/r:584x584/019a23c4a4957625a0ac9bf5ad8a8237.webp', now(), now()),
    -- КОФЕ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Кофе'), 'Кофе Капучино', 'https://media.dodostatic.net/image/r:584x584/0198ff09ed497723abee3ad26f60801b.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Кофе'), 'Кофе Латте', 'https://media.dodostatic.net/image/r:584x584/0198ff0831a471059ed1612f33c3c6db.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Кофе'), 'Кофе Американо', 'https://media.dodostatic.net/image/r:584x584/019a2f1eff2b787aa3516644c4869552.webp', now(), now()),
    -- НАПИТКИ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Морс Вишня', 'https://media.dodostatic.net/image/r:584x584/0198607dabe979abadbab281afb9ce60.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Морс Клюква', 'https://media.dodostatic.net/image/r:584x584/0198607ddb5778859568b0b329cc4f19.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Морс Черная Смородина', 'https://media.dodostatic.net/image/r:584x584/0198607d7826758f8c72f95e28662da9.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Coca-Cola', 'https://media.dodostatic.net/image/r:584x584/019c1e37841076d4b403e19f95fcf7d5.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Coca-Cola Zero', 'https://media.dodostatic.net/image/r:584x584/019c1e38e8a972469e31380053ce6df8.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Fanta', 'https://media.dodostatic.net/image/r:584x584/019c1e3967ec72ec96c6295ae704ff34.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Sprite', 'https://media.dodostatic.net/image/r:584x584/019a6d922d8d731d9580d87b3a9d6ca6.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Fusetea Персик', 'https://media.dodostatic.net/image/r:584x584/019a5d4e2a2d7183b1842b4909576e39.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Fusetea Манго-Ананас', 'https://media.dodostatic.net/image/r:584x584/019aa574fde6740cb07c3d0f2d738618.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Fusetea Манго-Ромашка', 'https://media.dodostatic.net/image/r:584x584/019a5d4d9bc270d0b90b8f8b3d8dac91.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Сок Piko Апельсин', 'https://media.dodostatic.net/image/r:584x584/019a6d8f883072d6be4d5e2451a7808b.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Напитки'), 'Сок Piko Персик', 'https://media.dodostatic.net/image/r:584x584/019a6d90078270d4b04319d8c14e32df.webp', now(), now()),
    -- ДЕСЕРТЫ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Яблочный крамбл', 'https://media.dodostatic.net/image/r:584x584/0199bd2fc16d7291b74a69f9577c0bf2.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Чизкейк карамельный с арахисом', 'https://media.dodostatic.net/image/r:584x584/0198f16a41917609920df1aac36144f6.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Бруслетики', 'https://media.dodostatic.net/image/r:584x584/0198f16c6d2b79a29cd909844b0b7a59.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Рулетики с корицей', 'https://media.dodostatic.net/image/r:584x584/01987e8a83a871dfa01fca49070ff9aa.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Маффин Три шоколада', 'https://media.dodostatic.net/image/r:584x584/0198f16fc3bf75d4a64fb5c74f94da86.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Маффин Соленая карамель', 'https://media.dodostatic.net/image/r:584x584/0198f17015f8730e8ec45b919d59df27.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Чизкейк Нью-Йорк', 'https://media.dodostatic.net/image/r:584x584/0198f16a90a0765eb03e66609842908c.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Чизкейк Банановый с шоколадным печеньем', 'https://media.dodostatic.net/image/r:584x584/0198f169f1a6747db40d0d1fae046c93.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Пончик Три шоколада', 'https://media.dodostatic.net/image/r:584x584/019ac60b6dc2770a959f60233829a3ff.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Пончик клубничный', 'https://media.dodostatic.net/image/r:584x584/019ac60b111170f68e05de98dd610b76.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Сырники', 'https://media.dodostatic.net/image/r:584x584/019a23c11cdb75d6baae6ef67825f654.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Десерты'), 'Сырники с малиновым вареньем', 'https://media.dodostatic.net/image/r:584x584/0198ff0df6cf7773ad4cf08376763a39.webp', now(), now()),
    -- СОУСЫ
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Тысяча островов', 'https://media.dodostatic.net/image/r:584x584/0198524091a4771c95824490b4116527.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Сырный', 'https://media.dodostatic.net/image/r:584x584/01986064cba5781e83bd53806fa54b42.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Чесночный', 'https://media.dodostatic.net/image/r:584x584/01986065152b78bbbe7c9dbee29700d4.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Барбекю', 'https://media.dodostatic.net/image/r:584x584/019860646b7a7733b35702260b98d30e.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Соус Цезарь', 'https://media.dodostatic.net/image/r:584x584/0198f165ec197094b2c93ef185f16cec.webp', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_categories WHERE name = 'Соусы'), 'Малиновое варенье', 'https://media.dodostatic.net/image/r:584x584/01986063ce9577d3a662add2593c9c86.webp', now(), now()),

    ON CONFLICT DO NOTHING
    RETURNING id, name
),

-- Insert Ingredients (Extra toppings or components)
inserted_ingredients AS (
    INSERT INTO ingredient (id, name, image_url, price, currency, created_at, updated_at)
    VALUES
        (uuidv7(), 'Сырный бортик', 'https://media.dodostatic.net/image/r:292x292/01991534ef937626a4cca9f027f99ea3.png', now(), now()),
        (uuidv7(), 'Моцарелла', 'https://media.dodostatic.net/image/r:292x292/0199ae76395f78f09d95f6af3b6d4f8b.png', now(), now()),
        (uuidv7(), 'Сыры чеддер и пармезан', 'https://media.dodostatic.net/image/r:292x292/01991534fc1175cc8fbceffda60604c6.png', now(), now())б
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
        (uuidv7(), 'Ванильный сироп', 'https://media.dodostatic.net/image/r:292x292/11ee7f0cf561809ea207cf000d289f85.png', now(), now()),
    ON CONFLICT DO NOTHING
    RETURNING id, name
),

-- Insert Product Items (Concrete SKUs with sizes, prices, and enum values)
inserted_items AS (
    INSERT INTO product_item (id, product_id, size, type, price, image_url, price, currency, created_at, updated_at)
    VALUES
    -- START OF PIZZA PRODUCT ITEM
        -- Ветчина и грибы
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '20см', 'Традиционный',null, 'https://media.dodostatic.net/image/r:520x520/019edfc87364751ab199ed2fe7ced206.png' 1650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019edfc90c6c766f90aa513f32fb7f22.png', 2350, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019edfca6a9370b98787ade9c962fea5.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019edfcb8dec74939ea3e388af5789f6.png', 4190, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019edfca7c6171ab8a99e98412c75498.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и грибы'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019edfcb979875aca4c32b370aefee90.png', 4190, 'KZT', now(), now()),

        -- Пицца Том ям с цыпленком
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2a260717ca56772ba84499b7e.png', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2ab8e76dca41f3e6a449a6a54.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2c19a721093cc13ab330377dc.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2d9257512ab118ff565c8ec48.png', 4250, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '25см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2b71a747196b060d0c07de77c.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2cdd274308ff33937834b86a4.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца Том ям с цыпленком'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019e82b2ef3572b5b44817abe5d11d99.png', 4250, 'KZT', now(), now()),

        -- Пицца том ям с креветками
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e829eabf770de97f0328970a2d909.png', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e829f250577dca2fea2868c8b7695.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e829fefda7725a40f4cadcb7560ac.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e82a036c0795c87444633b97a074d.png', 4990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '25см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019a7c5a1b4c707099a2162bd3e23cbe.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019e82a022d4746fbaa43f1f36fe2610.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пицца том ям с креветками'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019e82a081bd78d99bdda5461c4a9b53.png', 4990, 'KZT', now(), now()),

        -- Мясная
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4807d2c271178830a2f89b5af4ca.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4807dd8c777682d225b9a093bc24.png', 3090, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4807e836717a9cd581aaed1a0790.png', 4750, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4808012a7614ad0a74855509275a.png', 5990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d4807f43b7695a9c7a6a7be574349.png', 4750, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d48081f057280bec077339bfc3b80.png', 5990, 'KZT', now(), now()),

        -- Мясная с цыпленком
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4867ace375a49ac6b498b01fd3d7.png', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4867b9f475f7936fe5f266a190f3.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4867d1d971f482d52c7a4513a964.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4867f45a734685a69546a368d6ae.png', 4250, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d4867dfc97119b7299a687d2c20e8.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Мясная с цыпленком'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d486803ea774fa70176339792994a.png', 4250, 'KZT', now(), now()),

        -- Маргарита с Песто
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d48572a7173cc9cc62f7c73b2e184.png', 1400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4857333579aaa9315246c053962f.png', 2090, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d485742bd77288f87f77cdab0b347.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019d4857567f72c1be805e5e96254b80.png', 3950, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d48574c43781a8b60c3215b27ddac.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маргарита с Песто'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019d4857620a753caef31f5dba551670.png', 3950, 'KZT', now(), now()),

        -- Сладкая пицца пирог
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сладкая пицца пирог'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e8814d0737469b40988e870de40f0.png', 1400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сладкая пицца пирог'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e8814e1a8788e9ce314473b2c88c0.png', 1990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сладкая пицца пирог'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019e8814ef5e75169305f0b0f35a5f63.png', 2490, 'KZT', now(), now()),

        -- Чоризо фреш
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c42e467714d92f0b4e448f25386.png', 1400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c42ed0d76358fecb0d3cdc45128.png', 2090, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c42f704740cae3253e3af6994dc.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c43139778dfb8dc5199d294e87c.png', 3950, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c42ffbb730a97faaf88cc957ac9.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чоризо фреш'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c431eb07209ad7bf720062a6206.png', 3950, 'KZT', now(), now()),

        -- Сырная
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3aab1573828d80a1ebd4b22f3a.png', 1400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ab8fc7184b9f6d46a7aedc32e.png', 2090, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3abfda7669b8fdf577f86b07a9.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ad5b7765cadcc10d9bfa35cab.png', 3950, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ac60d72348383c1e9613243d8.png', 3250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3adbcb79169317f4cbb8ca908f.png', 3950, 'KZT', now(), now()),

        -- Чикен бомбони
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019b2193bab7701890ae8d253facb9f8.png', 3090, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019b2193c0b4786d8b688fddde3fa8de.png', 4750, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019b2193cfe073d58444e4cc86ccd998.png', 5990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019b2193c70f757c867b6b1bb400718e.png', 4750, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырная'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019b2193d55f7239a38e0fed1cf34905.png', 5990, 'KZT', now(), now()),

        -- Охотничья
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019c662f3e0b7141bc8706396110f74a.png', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019c662f4b3674c2bf95f828591b7117.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019c662f56be77088341eb92fc03018c.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019c662fd37b787e9ef36a5cca3312c3.png', 4990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019c662f76f871caad711b81c8d4d8df.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Охотничья'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019c662fc2487299a08dc86ee26616f7.png', 4990, 'KZT', now(), now()),

        -- Терияки
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019a08dc85797832a40793efc5b86b54.png', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019a08dc8fb079109ca831e6c53c35cf.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019a08dc9ec572a781b0ec251c7cf7e5.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/019a08dcee4f722984f417d68478db5c.png', 4990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019a08dcda8a729a9a9306be80804de4.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Терияки'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/019a08dcf676792da823e89bd1894dac.png', 4990, 'KZT', now(), now()),

        -- Креветки с песто
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c329fa373bc97b9a7eeadd39bf3.png', 2550, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c32a7fc7530896a04b8a151e113.png', 3450, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c32b0c177a48e70902864eef7fe.png', 5050, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c32d0e3727c8978061530c5d68c.png', 6290, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c32b7a47348bffeebca1c9449c4.png', 5050, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Креветки с песто'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c32d8c1747da82ac62ee0fe3c45.png', 6290, 'KZT', now(), now()),

        -- Чикен бургер
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c33df1f7514a7f69563d03a7fb8.png', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c33e536714398ba98bcbe2a4072.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c33ec9b7190911c2a7b133ee389.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c348275799288bcbda93f846946.png', 4250, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c33f43678fd81d670a599c28ed7.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чикен бургер'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c349383736eb0a70ab1a41305b0.png', 4250, 'KZT', now(), now()),

        -- Чилл Грилл
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c448b6077a0a838b631d70c3476.png', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c449546747899044fceecdd51da.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c44a523772c9f60f7fe864fdccc.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c443b8475b5bf8ab227eb8b9014.png', 4990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c445bfe7051ac26f0f5244f2edc.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чилл Грилл'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c44352075409ac81aa3a4b1cc58.png', 4990, 'KZT', now(), now()),

        -- Ветчина и сыр
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e1221710dbbf15a7b54d79406.png', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e1792762ebd250f254eb73313.png', 2250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e232d72f99537c7c7dc9cc78c.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e5f707608ab6e67d8d7a7d63b.png', 4250, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e282870628749a2c34be89b0f.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ветчина и сыр'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3e4642713bb1ae73bcdb256790.png', 4250, 'KZT', now(), now()),

        -- Двойной цыпленок
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ed44b7957af3c79b60d635d8c.png', 1650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ed94d740f9ce6ba3a7a7bcf66.png', 2350, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ee08e7147b2b1a38bc2f25f39.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3eff2479be9d0799e21afc711f.png', 4190, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3ee93a763499fcfc8f727a675e.png', 3650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Двойной цыпленок'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3f05f07971b6257b0e46687198.png', 4190, 'KZT', now(), now()),

        -- Аррива!
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c36612271c389544ce38db2ac90.png', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3665607097b2f76f426d0bb1c5.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c366eb7725f91d4efba9c5e5e2f.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c36850a72eca182b26d98912b82.png', 4990, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c367704792b8c114572a60fd78e.png', 4150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Аррива!'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c368c98753cadf4869a03e8346b.png', 4990, 'KZT', now(), now()),

        -- Бургер-пицца
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '20см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3d660b7549a93b8d5f932037c9.png', 1950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '25см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3d6e9371c4b308165bffefd637.png', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '30см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3d74bf71d59358fea743d9b27f.png', 4190, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '35см', 'Традиционный', null, 'https://media.dodostatic.net/image/r:520x520/01995c3da2d070ae954056945b051450.png', 5250, 'KZT', now(), now()),

        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '30см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3d8a077170a80b0c96f385c026.png', 4190, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бургер-пицца'), '35см', 'Тонкое', null, 'https://media.dodostatic.net/image/r:520x520/01995c3daa11725eb1bda9de1f9e60c0.png', 5250, 'KZT', now(), now()),
    -- END OF PIZZA PRODUCT ITEM

    -- START OF ЗАКУСКИ
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Покет-пицца ветчина и сыр'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019ef2d8bcba70a4a50c15ef19e7ce4f.webp', 1650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Покет-пицца Чилл Грилл'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019ef2cfd4137274b34ae5f6f14d6220.webp', 1650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Покет-пицца чоризо барбекю'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019ef2e12e4978a0830491b11085bc12.webp', 1650, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Паста Том ям'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019e827c11897284aab1fd3e0ee972e5.webp', 2950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Паста Мясная'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019d4de1f18171b0b1f43658240b818d.webp', 2790, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Ланчбокс Охотничий'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019c2f598101772196cd686d206346ee.webp', 2450, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Додстер Терияки'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01989b1249337885aa8967acfb9386af.webp', 1890, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Додстер'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01989b1249337885aa8967acfb9386af.webp', 1790, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Додстер с ветчиной'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198eb2de74b731181874e9184cb3b94.webp', 1550, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Острый Додстер'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198eb2eb82e75e795f3c3ebbaa0beaf.webp', 1790, 'KZT', now(), now()),
    -- END OF ЗАКУСКИ

    -- START OF КОКТЕЙЛИ
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Молочный коктейль Соленая карамель'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/019d3b9469187588a49742adcca90bf5.webp', 1700, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Молочный коктейль Соленая карамель'), '0.6L', null, null, 'https://media.dodostatic.net/image/r:584x584/019d3b9479ea78c38c65675fed48de6c.webp', 2550, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Молочный коктейль Фисташка'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a23c73cbf75b4bf71a6fb15340609.webp', 1900, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Молочный коктейль с печеньем Орео'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a23c7f60978d186dc1d4a14b607d2.webp', 1900, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Классический молочный коктейль'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a23c4a4957625a0ac9bf5ad8a8237.webp', 1500, 'KZT', now(), now()),
    -- END OF КОКТЕЙЛИ

    -- START OF COFEE
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Кофе Капучино'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff09ed497723abee3ad26f60801b.webp', 1050, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Кофе Капучино'), '0.4L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff097489789283e7a554694df553.webp', 1150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Кофе Латте'), '0.3L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff0831a471059ed1612f33c3c6db.webp', 1050, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Кофе Латте'), '0.4L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff083efc76c39a7ef1e76562736f.webp', 1150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Кофе Американо'), '0.4L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a2f1eff2b787aa3516644c4869552.webp', 950, 'KZT', now(), now()),
    -- END OF COFEE

    -- START OF НАПИТКИ
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Морс Вишня'), '0.45L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198607dabe979abadbab281afb9ce60.webp', 990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Морс Клюква'), '0.45L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198607ddb5778859568b0b329cc4f19.webp', 990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Морс Черная Смородина'), '0.45L', null, null, 'https://media.dodostatic.net/image/r:584x584/0198607d7826758f8c72f95e28662da9.webp', 990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Coca-Cola'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019c1e37841076d4b403e19f95fcf7d5.webp', 600, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Coca-Cola'), '1.0L', null, null, 'https://media.dodostatic.net/image/r:584x584/019c1e3794637663b2d55df3e8d1ac57.webp', 900, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Coca-Cola Zero'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019c1e38e8a972469e31380053ce6df8.webp', 600, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Fanta'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019c1e3967ec72ec96c6295ae704ff34.webp', 600, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Fanta'), '1.0L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a5d458c5e79c39bbd369808851a89.webp', 900, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Sprite'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a6d922d8d731d9580d87b3a9d6ca6.webp', 600, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Sprite'), '1.0L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a5d46b3867740ad810174015878d0.webp', 900, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Fusetea Персик'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a5d4e2a2d7183b1842b4909576e39.webp', 800, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Fusetea Манго-Ананас'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019aa574fde6740cb07c3d0f2d738618.webp', 800, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Fusetea Манго-Ромашка'), '0.5L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a5d4d9bc270d0b90b8f8b3d8dac91.webp', 800, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сок Piko Апельсин'), '0.2L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a6d8f883072d6be4d5e2451a7808b.webp', 550, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сок Piko Апельсин'), '1.0L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a5d50b0e8715ea62070cdb1706d9a.webp', 1700, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сок Piko Персик'), '0.2L', null, null, 'https://media.dodostatic.net/image/r:584x584/019a6d90078270d4b04319d8c14e32df.webp', 550, 'KZT', now(), now()),
    -- END OF НАПИТКИ

    -- START OF ДЕСЕРТЫ
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Яблочный крамбл'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0199bd2fc16d7291b74a69f9577c0bf2.webp', 1350, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чизкейк карамельный с арахисом'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f16a41917609920df1aac36144f6.webp', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бруслетики'), '8шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f16c6d2b79a29cd909844b0b7a59.webp', 950, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Бруслетики'), '16шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f16c72fa753b87aede36fa9c8094.webp', 1250, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Рулетики с корицей'), '16шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01987e8a83a871dfa01fca49070ff9aa.webp', 1050, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маффин Три шоколада'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f16fc3bf75d4a64fb5c74f94da86.webp', 850, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Маффин Соленая карамель'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f17015f8730e8ec45b919d59df27.webp', 850, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чизкейк Нью-Йорк'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f16a90a0765eb03e66609842908c.webp', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чизкейк Банановый с шоколадным печеньем'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f169f1a6747db40d0d1fae046c93.webp', 1590, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пончик Три шоколада'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019ac60b6dc2770a959f60233829a3ff.webp', 990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Пончик клубничный'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019ac60b111170f68e05de98dd610b76.webp', 990, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырники'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019a23c11cdb75d6baae6ef67825f654.webp', 1150, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырники с малиновым вареньем'), '2шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff0df6cf7773ad4cf08376763a39.webp', 1450, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырники с малиновым вареньем'), '4шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198ff0dfc8c7965bd00db456098b891.webp', 2350, 'KZT', now(), now()),
    -- END OF ДЕСЕРТЫ

    -- START OF СОУСЫ
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Тысяча островов'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198524091a4771c95824490b4116527.webp', 400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Сырный'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01986064cba5781e83bd53806fa54b42.webp', 400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Чесночный'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01986065152b78bbbe7c9dbee29700d4.webp', 400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Барбекю'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/019860646b7a7733b35702260b98d30e.webp', 400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Соус Цезарь'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/0198f165ec197094b2c93ef185f16cec.webp', 400, 'KZT', now(), now()),
        (uuidv7(), (SELECT id FROM inserted_products WHERE name = 'Малиновое варенье'), '1шт', null, null, 'https://media.dodostatic.net/image/r:584x584/01986063ce9577d3a662add2593c9c86.webp', 400, 'KZT', now(), now()),
    -- END OF СОУСЫ
    ON CONFLICT DO NOTHING
    RETURNING id, product_id, size
)

-- ============================================================================
-- POPULATE STANDARDIZED JOIN TABLES
-- ============================================================================

-- Link Cities and Categories
, link_city_category AS (
    INSERT INTO city_category (city_id, category_id, is_available)
    SELECT c.id, cat.id, true FROM inserted_cities c CROSS JOIN inserted_categories cat
    ON CONFLICT DO NOTHING
)

-- Link Cities and Products
, link_city_product AS (
    INSERT INTO city_product (city_id, product_id, is_available, updated_at)
    SELECT c.id, p.id, true, now() FROM inserted_cities c CROSS JOIN inserted_products p
    ON CONFLICT DO NOTHING
)

-- Link Cities and Ingredients
, link_city_ingredient AS (
    INSERT INTO city_ingredient (city_id, ingredient_id)
    SELECT c.id, ing.id FROM inserted_cities c CROSS JOIN inserted_ingredients ing
    ON CONFLICT DO NOTHING
)

-- Link Product Items to Ingredients (Allow toppings on Pepperoni sizes)
, link_item_ingredient AS (
    INSERT INTO product_item_ingredient (product_item_id, ingredient_id)
    SELECT item.id, ing.id
    FROM inserted_items item
    JOIN inserted_products prod ON item.product_id = prod.id
    CROSS JOIN inserted_ingredients ing
    WHERE prod.name = 'Pepperoni Pizza'
    ON CONFLICT DO NOTHING
)

-- Bulk Link ALL Product Items to ALL Cities initially
INSERT INTO city_product_item (city_id, product_item_id)
SELECT c.id, item.id
FROM inserted_cities c
CROSS JOIN inserted_items item
ON CONFLICT (city_id, product_item_id) DO NOTHING;


-- ============================================================================
-- FINE-TUNE AVAILABILITY PER REGION (EXCEPTIONS)
-- ============================================================================

-- Exception: Almaty does not get the LARGE Pepperoni Pizza
DELETE FROM city_product_item
WHERE city_id = (SELECT id FROM city WHERE name = 'Almaty')
  AND product_item_id = (
      SELECT pi.id
      FROM product_item pi
      JOIN product p ON pi.product_id = p.id
      WHERE p.name = 'Pepperoni Pizza' AND pi.size = 'LARGE'
  );

-- Exception: Astana does not get SMALL or LARGE Pepperoni Pizzas (Only Medium)
DELETE FROM city_product_item
WHERE city_id = (SELECT id FROM city WHERE name = 'Astana')
  AND product_item_id IN (
      SELECT pi.id
      FROM product_item pi
      JOIN product p ON pi.product_id = p.id
      WHERE p.name = 'Pepperoni Pizza' AND pi.size IN ('SMALL', 'LARGE')
  );

-- Exception: Astana does not get MEDIUM or LARGE Coca-Cola (Only Small)
DELETE FROM city_product_item
WHERE city_id = (SELECT id FROM city WHERE name = 'Astana')
  AND product_item_id IN (
      SELECT pi.id
      FROM product_item pi
      JOIN product p ON pi.product_id = p.id
      WHERE p.name = 'Coca-Cola' AND pi.size IN ('MEDIUM', 'LARGE')
  );

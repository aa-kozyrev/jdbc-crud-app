-- pish.product

CREATE TABLE IF NOT EXISTS pish.product(
    id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL, -- ID продукта
	"name" varchar NOT NULL, -- Наименование/Описание продукта
	price numeric(100, 2) DEFAULT 0 NOT NULL, -- Cтоимость продукта
	count int4 NOT NULL, -- Количество
	category varchar NULL, -- Категория
	CONSTRAINT product_check_count CHECK ((count >= 0)),
	CONSTRAINT product_check_price CHECK ((price >= (0)::numeric)),
	CONSTRAINT product_pk PRIMARY KEY (id)
);
COMMENT ON TABLE pish.product IS 'Продукты';

COMMENT ON COLUMN pish.product.id IS 'ID продукта';
COMMENT ON COLUMN pish.product."name" IS 'Наименование/Описание продукта';
COMMENT ON COLUMN pish.product.price IS 'Cтоимость продукта';
COMMENT ON COLUMN pish.product.count IS 'Количество';
COMMENT ON COLUMN pish.product.category IS 'Категория';

ALTER TABLE pish.product OWNER TO pish;
GRANT ALL ON TABLE pish.product TO pish;

COMMIT;

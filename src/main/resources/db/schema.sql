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

-- pish.customer

CREATE TABLE IF NOT EXISTS pish.customer (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL, -- ID клиента
	first_name varchar NOT NULL, -- Имя клиента
	last_name varchar NOT NULL, -- Фамилия клиента
	phone varchar NOT NULL, -- Телефон клиента
	email varchar NULL, -- E-mail клиента
	CONSTRAINT customer_pk PRIMARY KEY (id),
	CONSTRAINT customer_unique_phone UNIQUE (phone)
);
COMMENT ON TABLE pish.customer IS 'Клиенты';

COMMENT ON COLUMN pish.customer.id IS 'ID клиента';
COMMENT ON COLUMN pish.customer.first_name IS 'Имя клиента';
COMMENT ON COLUMN pish.customer.last_name IS 'Фамилия клиента';
COMMENT ON COLUMN pish.customer.phone IS 'Телефон клиента';
COMMENT ON COLUMN pish.customer.email IS 'E-mail клиента';

ALTER TABLE pish.customer OWNER TO pish;
GRANT ALL ON TABLE pish.customer TO pish;

-- pish.order_status

CREATE TABLE IF NOT EXISTS pish.order_status (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL, -- ID статуса заказа
	"name" varchar NOT NULL, -- Имя статуса заказа
	description varchar NULL, -- Описание статуса заказа
	CONSTRAINT order_status_pk PRIMARY KEY (id),
	CONSTRAINT order_status_unique_name UNIQUE (name)
);
COMMENT ON TABLE pish.order_status IS 'Статусы заказов (справочник)';

COMMENT ON COLUMN pish.order_status.id IS 'ID статуса заказа';
COMMENT ON COLUMN pish.order_status."name" IS 'Имя статуса заказа';
COMMENT ON COLUMN pish.order_status.description IS 'Описание статуса заказа';

ALTER TABLE pish.order_status OWNER TO pish;
GRANT ALL ON TABLE pish.order_status TO pish;

-- pish."order"

CREATE TABLE IF NOT EXISTS pish."order" (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL, -- Номер заказа
	product_id int4 NOT NULL, -- Продукт
	customer_id int4 NOT NULL, -- Клиент
	order_date timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Дата заказа
	count int4 NOT NULL, -- Количество продуктов в заказе
	status int4 NOT NULL, -- Статус заказа
	CONSTRAINT order_check_count CHECK ((count >= 0)),
	CONSTRAINT order_pk PRIMARY KEY (id),
	CONSTRAINT order_customer_fk FOREIGN KEY (customer_id) REFERENCES pish.customer(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT order_order_status_fk FOREIGN KEY (status) REFERENCES pish.order_status(id),
	CONSTRAINT order_product_fk FOREIGN KEY (product_id) REFERENCES pish.product(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS order_customer_id_idx ON pish."order" (customer_id);
CREATE INDEX IF NOT EXISTS order_order_date_idx ON pish."order" (order_date);
CREATE INDEX IF NOT EXISTS order_product_id_idx ON pish."order" (product_id);
CREATE INDEX IF NOT EXISTS order_status_idx ON pish."order" (status);
COMMENT ON TABLE pish."order" IS 'Заказы';

COMMENT ON COLUMN pish."order".id IS 'Номер заказа';
COMMENT ON COLUMN pish."order".product_id IS 'Продукт';
COMMENT ON COLUMN pish."order".customer_id IS 'Клиент';
COMMENT ON COLUMN pish."order".order_date IS 'Дата заказа';
COMMENT ON COLUMN pish."order".count IS 'Количество продуктов в заказе';
COMMENT ON COLUMN pish."order".status IS 'Статус заказа';

ALTER TABLE pish."order" OWNER TO pish;
GRANT ALL ON TABLE pish."order" TO pish;

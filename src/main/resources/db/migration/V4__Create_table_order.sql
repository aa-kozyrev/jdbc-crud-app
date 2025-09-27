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

COMMIT;
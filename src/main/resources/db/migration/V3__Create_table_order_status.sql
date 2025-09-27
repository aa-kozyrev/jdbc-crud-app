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

COMMIT;

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

COMMIT;

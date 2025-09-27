
INSERT INTO pish.order_status ("name", description) VALUES('NEW', 'Новый');
INSERT INTO pish.order_status ("name", description) VALUES('WAITING_PAY', 'Ожидание оплаты');
INSERT INTO pish.order_status ("name", description) VALUES('PAID', 'Оплачен');
INSERT INTO pish.order_status ("name", description) VALUES('IN_PROGRESS', 'Сборка');
INSERT INTO pish.order_status ("name", description) VALUES('DELIVERY', 'Доставка');
INSERT INTO pish.order_status ("name", description) VALUES('DELIVERED', 'Доставлен');
INSERT INTO pish.order_status ("name", description) VALUES('CLOSED', 'Закрыт');
INSERT INTO pish.order_status ("name", description) VALUES('CANCELED', 'Отменен');
INSERT INTO pish.order_status ("name", description) VALUES('REJECTED', 'Отклонен');
INSERT INTO pish.order_status ("name", description) VALUES('RETURN', 'Возврат');

COMMIT;

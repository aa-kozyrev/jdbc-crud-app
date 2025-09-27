
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 1, CURRENT_TIMESTAMP, 3, 1);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(3, 2, CURRENT_TIMESTAMP - INTERVAL '1 hour', 8, 2);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(4, 3, CURRENT_TIMESTAMP - INTERVAL '1 day', 99, 3);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(5, 4, CURRENT_TIMESTAMP - INTERVAL '5 hour', 12, 4);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(6, 5, CURRENT_TIMESTAMP - INTERVAL '1 day 2 hour', 5, 5);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(7, 6, CURRENT_TIMESTAMP - INTERVAL '2 day 8 hour', 1, 6);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(8, 7, CURRENT_TIMESTAMP - INTERVAL '1 week', 7, 7);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(9, 8, CURRENT_TIMESTAMP - INTERVAL '2 day 10 hour', 2, 8);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(10, 9, CURRENT_TIMESTAMP - INTERVAL '3 day 1 hour', 203, 9);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(11, 10, CURRENT_TIMESTAMP - INTERVAL '3 day 5 hour', 1999, 10);

INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 11, CURRENT_TIMESTAMP - INTERVAL '4 day', 1, 1);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(3, 1, CURRENT_TIMESTAMP - INTERVAL '10 day 2 hour', 3, 2);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(4, 1, CURRENT_TIMESTAMP - INTERVAL '14 day 4 hour', 4, 3);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(5, 2, CURRENT_TIMESTAMP - INTERVAL '7 day 8 hour', 9, 4);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 3, CURRENT_TIMESTAMP - INTERVAL '5 day 9 hour', 8, 5);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(3, 4, CURRENT_TIMESTAMP - INTERVAL '5 hour', 13, 6);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(4, 5, CURRENT_TIMESTAMP - INTERVAL '5 day 14 hour', 47, 7);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 6, CURRENT_TIMESTAMP - INTERVAL '8 day 22 hour', 55, 8);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 6, CURRENT_TIMESTAMP - INTERVAL '9 day 3 hour', 18, 9);
INSERT INTO pish."order" (product_id, customer_id, order_date, count, status) VALUES(2, 1, CURRENT_TIMESTAMP - INTERVAL '10 day 18 hour', 798, 10);

COMMIT;

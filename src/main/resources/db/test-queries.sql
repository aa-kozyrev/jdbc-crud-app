/*********************************************************************************************************
*** 5 запросов на чтение (в том числе JOIN с несколькими таблицами, агрегаты, сортировка, фильтрация). ***
**********************************************************************************************************/

-- 1) Вывести все заказы, за последние 7 дней у которых кол-во единиц товара больше 10
--    Вывести информацию о заказе (номер, дата, единиц товара, статус), заказанном товаре (наименование/стоимость) и покупателе (ФИ, контакты)
--    Результаты отсортировать по дате заказа (самые "свежие" в начале)
select o.id , o.order_date , o.count || ' шт.' as "count" , 
	   os.description || ' (' || os."name" || ')' as "status" , 
	   p."name" , p.price || ' руб./шт.' as "price" , 
	   c.last_name || ' ' || c.first_name as "client", c.phone , c.email
from "order" o
left join product p on o.product_id = p.id 
left join customer c on o.customer_id = c.id 
left join order_status os on o.status = os.id 
where o.count > 10
and o.order_date >= CURRENT_TIMESTAMP - interval '7 days'
order by o.order_date desc;

-- 2) Вывести сколько раз в заказах встречаются товары; исключить заказы, которые потерпели "фиаско" (CANCELED/REJECTED),
select p.id , p."name" , count(*) cnt
from "order" o
left join order_status os on o.status = os.id 
left join product p on o.product_id = p.id  
where os."name" not in('CANCELED', 'REJECTED')
group by p.id, p."name"
order by cnt desc, p."name";

-- 3) Вывести "Топ-10" самых "дорогих" заказов.
select o.id , o.order_date , p."name", o.count || ' шт. * ' || p.price || ' руб.' as "count * price" , (p.price * o.count) as "summa"
from "order" o 
left join product p on o.product_id = p.id 
order by "summa" desc
limit 10;

-- 4) Вывести информацию о покупателях, которые не сделали ни одного заказа
select c.*
from customer c 
where c.id not in(
	select o.customer_id  
	from "order" o
);

-- 5) Вывести информацию о тех покупателях, у которых отсутствует хотя-бы один из контактов (email, телефон)
select c.*
from customer c
where c.email is null 
or c.phone is null;


/*********************************************************************************************************
*** 3 запроса на изменение (UPDATE)                                                                    ***
*********************************************************************************************************/

-- 1) Изменить фамилию определенного покупателя  
update customer
set last_name = 'Ручкина'
where phone = '79000000014';
commit;
  
-- 2) Изменить статус заказов с NEW на WAITING_PAY
update "order"
set status = (
	select id
	from order_status 
	where "name" = 'WAITING_PAY')
where status = (
	select id
	from order_status 
	where "name" = 'NEW'
);
commit;

-- 3) Изменить количество единиц товара на складе для определенного товара
update product
set count = 1
where id = 6;
commit;


/*********************************************************************************************************
*** 2 запроса на удаление (DELETE)                                                                     ***
*********************************************************************************************************/

-- 1) Удалить покупателей, не сделавших заказ
delete 
from customer
where id not in(
	select customer_id  
	from "order"
);
commit;

-- 2) Удалить заказы, находящиеся в статусе REJECTED
delete
from "order"
where status = (
	select id
	from order_status 
	where "name" = 'REJECTED')
;
commit;


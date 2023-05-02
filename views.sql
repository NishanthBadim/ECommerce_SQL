DROP VIEW IF EXISTS ANNUAL_TOP_MEMBERS;
CREATE VIEW ANNUAL_TOP_MEMBERS
AS
SELECT First_name, Last_name, start_date AS membership_enrollment, SUM(subtotal) AS order_subtotal
FROM PERSON
NATURAL JOIN customer
NATURAL JOIN `member`
NATURAL JOIN membership_card
NATURAL JOIN payment
NATURAL JOIN order_info
NATURAL JOIN `order`
WHERE create_time >= DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 1 YEAR)
GROUP BY member_id
ORDER BY order_subtotal DESC
LIMIT 3;


DROP VIEW IF EXISTS POPULAR_PRODUCT_SOLD;
CREATE VIEW POPULAR_PRODUCT_SOLD
AS
select product_id, product_name, product_description, count(product_id) as total_products_sold from order_info 
natural join `order`
natural join product
where create_time >= DATE_SUB(current_timestamp, INTERVAL 1 MONTH)
group by product_id
order by total_products_sold desc;





DROP VIEW IF EXISTS POTENTIAL_MEMBER_CUSTOMER;
CREATE VIEW POTENTIAL_MEMBER_CUSTOMER
AS
SELECT person_id, first_name, last_name, dob, gender, count(*) as total_orders FROM person
NATURAL JOIN customer
NATURAL JOIN `payment`
NATURAL JOIN `order_info`
WHERE customer_id NOT IN ( SELECT member_id FROM `member`)
AND payment_time >= DATE_SUB(current_timestamp, INTERVAL 1 MONTH)
GROUP BY customer_id having total_orders > 10 
ORDER BY total_orders desc;

DROP VIEW IF EXISTS GOLD_STORE;
CREATE VIEW GOLD_STORE
AS
select store_id, store_name, count(store_id) as orders from customer
natural join store
natural join order_info
natural join payment
where payment_time >= DATE_SUB(current_timestamp, INTERVAL 1 MONTH)
group by store_id 
order by orders desc
limit 1;


DROP VIEW IF EXISTS TOP_QUARTER_CASHIER;
CREATE VIEW TOP_QUARTER_CASHIER
AS
SELECT distinct(cashier_id), person.first_name, person.last_name, payment_time, count(*) as total_orders_served FROM cashier 
INNER JOIN employee on employee.employee_id = cashier.cashier_id 
INNER JOIN person on person.person_id = employee.person_id
NATURAL JOIN payment_info
NATURAL JOIN payment
WHERE payment_time >= DATE_SUB(current_timestamp, INTERVAL 3 MONTH)
GROUP BY cashier_id
ORDER BY total_orders_served DESC
LIMIT 1;
select first_name, last_name from person
natural join employee
where member_id is not null;


select role_name as role, count(*) as Number_of_employees, SUM(salary) as Average_salary from employee
natural join employment
group by role_name;


select AVG(total_orders) from POTENTIAL_MEMBER_CUSTOMER;


select first_name, last_name from POPULAR_PRODUCT_SOLD
natural join product
natural join sell
natural join store
natural join visit
natural join customer
natural join person
group by customer_id;




select * from person
natural join employee
inner join employment on employee.employee_id = employment.employee_id 
left join membership_card on employee.member_id = membership_card.member_id
where membership_card.start_date between DATE_ADD(CAST(employment.start_date as DATE), INTERVAL 1 month) and CAST(employment.start_date as DATE);


drop view if exists member_with_most_guests;
create view member_with_most_guests 
as 
select `member`.member_id from guest
left join `member` on guest.member_id = `member`.member_id
group by `member`.member_id
order by count(*) desc
limit 1;

drop view if exists person_employee_member;
create view person_employee_member
as
select person.person_id, first_name, last_name, employee.member_id from person 
inner join employee on person.person_id = employee.person_id
-- inner join customer on person.person_id = customer.person_id
right join `member` on employee.member_id = `member`.member_id;


select first_name, last_name from person_employee_member where member_id = (select * from member_with_most_guests);

drop view if exists person_employee_member;
create view person_employee_member
as
select person.person_id, employee.member_id, first_name, last_name from person join employee on person.person_id = employee.person_id 
union
select person.person_id, customer.member_id, first_name, last_name from person join customer on person.person_id = customer.person_id;




select store_id, store_name, count(*) AS total_distinct_products from store 
natural join sell
where product_quantity > 0
group by store_id
order by total_distinct_products desc
limit 1;


select product_id, product_name, store_name, product_price from product 
natural join sell
natural join store
group by product_id
order by product_id;


select store_id, store_name, floor_id, floor_num as floor_number, count(*) as total_stores from store
inner join `floor` on store.store_floor_location =`floor`.floor_num
group by floor_id
order by total_stores desc
limit 1;



select store_id, store_name, order_id, create_time, count(*) as total_orders from store 
natural join order_info
natural join `order`
where create_time >= DATE_SUB(current_timestamp, INTERVAL 1 week)
group by store_id
order by total_orders desc
limit 1; 



-- 6. Find the names of members who bring the most number guests.

select `member`.member_id, guest_id, count(*) as total_guests from guest
join member on guest.member_id = `member`.member_id
 group by `member`.member_id
order by total_guests desc;

select * from guest;
select person.first_name, person.last_name from person
JOIN (SELECT MEMBER.MEMBER_ID FROM GUEST 
JOIN MEMBER ON GUEST.MEMBER_ID=MEMBER.MEMBER_ID
GROUP BY MEMBER.MEMBER_ID)
JOIN EMPLOYEE ON employee.person_id = member.person_id
JOIN CUSTOMER ON customer.person_id = member.person_id
GROUP BY member.member_id
ORDER BY PERSON.first_name DESC;

-- 8. Find the floor staff who have taken charge of all the floors in the past 1 week.
select floor_staff_id, floor_id from floor_staff 
natural join `floor` 
group by floor_staff_id having count(floor_id) = (SELECT count(*) FROM floor_managing_log WHERE WEEKOFYEAR(date)=WEEKOFYEAR(CURDATE()));


SELECT floor_id FROM `floor` where count(floor_id) = (SELECT count(*) FROM floor_managing_log WHERE WEEKOFYEAR(date)=WEEKOFYEAR(CURDATE()));

-- 11. List the schedule of the Gold-Store.
select * from schedule where store_id = ( select store_id from GOLD_STORE);


-- 13. Find the employee who supervises the most number of floor staffs.
select floor_staff_id, supervised_by, count(*) as total from floor_staff 
group by supervised_by
order by total desc
limit 1;


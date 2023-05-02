-- PERSON

drop table if exists person;
create table person (
person_id int(9) NOT NULL AUTO_INCREMENT,
address varchar(1028) NOT NULL,
first_name varchar(32) NOT NULL,
middle_name varchar(32),
last_name varchar(32) NOT NULL,
age int(3),
dob DATE,
gender ENUM('Male','Female') NOT NULL,
PRIMARY KEY (person_id));

-- PERSON_PHONE_NUMBER

drop table if exists person_phone_number;
create table person_phone_number (
person_id int(9) NOT NULL,
phone_number varchar(14) NOT NULL,
PRIMARY KEY(person_id, phone_number),
FOREIGN KEY(person_id) references person(person_id)
);

-- EMPLOYEE

drop table if exists employee;
create table employee (
employee_id varchar(4) NOT NULL,
salary int(12) NOT NULL,
date_of_birth DATE NOT NULL,
member_id int(9),
person_id int(9),
primary key (employee_id),
FOREIGN KEY(member_id) references `member`(member_id),
foreign key(person_id) references person(person_id),
CONSTRAINT Employee_id_check CHECK (REGEXP_LIKE(employee_id, 'E[0-9]{3}'))
);

DROP PROCEDURE IF EXISTS Validate_employee_age;
DELIMITER $$
CREATE PROCEDURE Validate_employee_age(
    IN date_of_birth DATE
)
DETERMINISTIC
NO SQL
BEGIN
    IF ((DATEDIFF(CURRENT_TIMESTAMP, date_of_birth) / 365.25) - (CASE WHEN MONTH(date_of_birth) = MONTH(CURRENT_TIMESTAMP) AND DAY(date_of_birth) > DAY(CURRENT_TIMESTAMP) THEN 1 ELSE 0 END)) < 18 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Age must be not be less than 18';
    END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS Validate_employee_insert;
DELIMITER $$
CREATE TRIGGER Validate_employee_insert
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    CALL Validate_employee_age(NEW.date_of_birth);
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS Validate_employee_update;
DELIMITER $$
CREATE TRIGGER Validate_employee_update
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    CALL Validate_employee_age(NEW.date_of_birth);
END$$
DELIMITER ;

-- EMPLOYMENT

drop table if exists employment;
create table employment (
employee_id varchar(4) NOT NULL,
role_name ENUM('Manager', 'Floor Staff', 'Cashier') NOT NULL,
start_date DATETIME DEFAULT CURRENT_TIMESTAMP,
primary key(employee_id, role_name, start_date),
foreign key(employee_id) references employee(employee_id)
);

-- MANAGER

drop table if exists manager;
create table manager(
manager_id varchar(4) not null,
primary key(manager_id),
foreign key(manager_id) references employee(employee_id)
);

-- FLOOR STAFF

drop table if exists floor_staff;
create table floor_staff(
floor_staff_id varchar(4) not null,
supervised_by varchar(4) not null,
primary key(floor_staff_id),
foreign key(floor_staff_id) references employee(employee_id),
foreign key(supervised_by) references manager(manager_id)
);

-- CASHIER

drop table if exists cashier;
create table cashier(
cashier_id varchar(4) not null,
supervised_by varchar(4) not null,
primary key(cashier_id),
foreign key(cashier_id) references employee(employee_id),
foreign key(supervised_by) references manager(manager_id)
);

-- CUSTOMER

drop table if exists customer;
create table customer(
customer_id int(9) not null,
person_id int(9) not null,
member_id int(9),
primary key(customer_id),
foreign key(person_id) references person(person_id),
foreign key(member_id) references `member`(member_id)
);


-- FLOOR

drop table if exists `floor`;
create table `floor`(
floor_id int(9) not null,
floor_num int(3) not null,
floor_staff_id varchar(4) not null,
primary key(floor_id),
foreign key(floor_staff_id) references floor_staff(floor_staff_id)
);

-- FLOOR MANAGING LOG

drop table if exists floor_managing_log;
create table floor_managing_log(
floor_id int(9) not null,
floor_day ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') not null,
`date` DATE,
primary key(floor_id, floor_day),
foreign key(floor_id) references `floor`(floor_id)
);


-- STORE

drop table if exists store;
create table store(
store_id int(9) not null primary key,
store_name varchar(50),
store_floor_location int(3) not null
);


-- STORE TYPE WEAK ENTITY

drop table if exists store_type;
create table store_type(
store_id int(9) not null,
store_type varchar(100) not null,
primary key(store_id, store_type)
);


-- FLOOR_FLOOR MANAGING LOG_STORE TERNARY RELATIONSHIP ENTITY

drop table if exists store_info;
create table store_info(
store_id int(9) not null,
floor_id int(9) not null,
primary key(store_id, floor_id)
);

-- SCHEDULE

drop table if exists `schedule`;
create table `schedule`(
employee_manager_id varchar(4) not null,
store_day varchar(20) not null,
open_time timestamp default current_timestamp,
close_time timestamp default current_timestamp,
day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'),
store_id int(9) not null,
primary key(employee_manager_id, store_day),
foreign key(employee_manager_id) references manager(manager_id),
foreign key(store_id) references store(store_id)
);


-- CUSTOMER_STORE JOIN ENTITY

drop table if exists visit;
create table visit(
customer_id int(9) not null,
store_id int(9) not null,
primary key(customer_id, store_id),
foreign key(customer_id) references customer(customer_id),
foreign key(store_id) references store(store_id)
);


-- MEMBER

drop table if exists `member`;
create table `member`(
member_id int(9) not null primary key
);

-- GUEST

drop table if exists guest;
create table guest(
guest_id int(9) not null,
guest_name varchar(40) not null,
address varchar(80),
member_id int(9) not null,
primary key(member_id, guest_id),
foreign key(member_id) references `member`(member_id)
);


-- GUEST_PHONE NUMBER 

drop table if exists guest_phone_number;
create table guest_phone_number (
guest_member_id int(9) NOT NULL,
phone_number varchar(14) NOT NULL,
PRIMARY KEY(guest_member_id, phone_number),
FOREIGN KEY(guest_member_id) references guest(member_id)
);


-- MEMBERSHIP CARD

drop table if exists membership_card;
create table membership_card(
card_id int(9) not null primary key,
start_date date not null,
payment_points int(6) default 0 not null,
member_id int(9) not null,
FOREIGN KEY(member_id) references `member`(member_id)
);


-- PROMOTION

drop table if exists promotion;
create table promotion(
promotion_card_id int(9) not null,
promotion_id int(9) not null,
description varchar(100),
primary key(promotion_card_id, promotion_id),
foreign key(promotion_card_id) references membership_card(card_id)
);


-- THINK OF OFFER JOIN ENTITY


-- PAYMENT

-- add membership card id
drop table if exists payment;
create table payment(
payment_id int(9) not null primary key,
payment_order varchar(128),
payment_info varchar(128),
payment_time timestamp default current_timestamp,
customer_id int(9) not null,
membership_card_id int(9),
foreign key(customer_id) references customer(customer_id),
foreign key(membership_card_id) references membership_card(card_id)
);


-- PAYMENT METHOD
drop table if exists payment_method;
create table payment_method(
payment_id int(9) not null,
payment_method ENUM('Cash','Credit Card','Debit Card','Membership Card') not null,
primary key(payment_id, payment_method),
foreign key(payment_id) references payment(payment_id)
);


-- PRODUCT

drop table if exists product;
create table product(
product_id int(9) not null,
product_name varchar(128),
product_description varchar(1028),
primary key(product_id)
);

-- STORE PRODUCT JOIN ENTITY

drop table if exists sell;
create table sell(
store_id int(9) not null,
product_id int(9) not null,
product_quantity int(3) not null, -- stock 
product_price int(5) not null,
primary key(store_id, product_id),
foreign key(store_id) references store(store_id),
foreign key(product_id) references product(product_id)
);



-- ORDER

drop table if exists `order`;
create table `order`(
order_id int(9) not null primary key,
create_time timestamp default current_timestamp,
product_id int(9) not null,
subtotal int(10),
foreign key(product_id) references product(product_id)
);


-- ORDER PLACED INFO
drop table if exists order_info;
create table order_info(
store_id int(9) not null,
payment_id int(9) not null,
order_id int(9) not null,
primary key(store_id, payment_id, order_id),
foreign key(store_id) references store(store_id),
foreign key(payment_id) references payment(payment_id),
foreign key(order_id) references `order`(order_id)
);


-- PAYMENT MADE INFO
drop table if  exists payment_info;
create table payment_info(
cashier_id varchar(4) not null,
payment_id int(9) not null,
customer_id int(9) not null,
primary key(cashier_id, payment_id, customer_id),
foreign key(payment_id) references payment(payment_id),
foreign key(cashier_id) references cashier(cashier_id),
foreign key(customer_id) references customer(customer_id)
);




 
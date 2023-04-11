# ECommerce_SQL



The Happiness Shopping Mall would like one relational database to store the information about
their management system to be able to carry out their work in an organized way. They have some
major modules such as Person (Employee and Customer), Products and Stores.
In the system, there are Employees and Customers. Details of a Customer such as Customer ID,
Name (First, Middle, Last), Address, Gender, Date of Birth and Phone numbers (one person may
have more than one phone number) are recorded.

Each employee has unique Employee ID. The Employee ID must have the exact format
“EXXX”, where X is a number from 0-9. More information of an Employee such as Name (First,
Middle, Last), Salary, Address, Gender, Date of Birth and Phone number are recorded.
Employee Must be at least 18 or older. Employee is further classified as Manager, Floor Staff
and Cashier. The start date of the designation of each employee is stored. A cashier is supervised
by a floor staff, and a floor staff is supervised by a Manager. A floor staff is responsible for
managing the stores at a floor. Each floor staff can only manage one floor for each day, but may
be assigned to manage different floors on different days. A floor managing log is created for
storing such information.
Both Employee and Customer can join the membership and become a Member of the shopping
mall. Each member is issued with a unique membership card by a Manager. Members can use the
membership card to make the payments, and they will collect points through the payments. The
card also records the start date of the membership.

Sometimes promotional discounts are offered on the membership card and details such as
promotion ID and promotion description are recorded. The Promotional IDs are not unique in the
whole system but are unique among all promotions associated with one membership card.
Members can bring guests with them to shopping together and share their membership cards.
Guests’ information is maintained which includes guest ID, guest name, guest address, and guest
phone number. Guest IDs are temporary IDs that a person gets when they shop as a guest of a
member. Each guest ID is not unique on its own and cannot be used to identify a guest in the
system.

There are many Stores located on different floors. Information about a store such as store ID,
store name, store floor location and store type (Clothes, Food, Drink, Book and so on) are
recorded. Each store opens and closes at specific times (may be different from Monday to
Sunday) following a schedule table. The manager of the mall can adjust the schedule table.
Stores sell various Products. A product has a unique id and other information (such as name and
description). A product may be sold in different stores at different prices. Each store has their
own records about products, such as the quantity of the product in stock.

Customers can place orders in stores. Each store will maintain the detailed information about the
order. Each order has unique order ID and the created time of the order is recorded. Each order
may contain multiple number and multiple kinds of products. Each order also records the prices
of these products and the order subtotal. Customers make the Payment of their orders with
Cashiers. Payment information such as ID, payment time, method (cash, credit or debit card,
membership card), amount and other information are recorded

-- Step 1: Create a View
use sakila;
create view rental_info as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, c.email, count(*) as rental_count
from customer c
join rental r
	on c.customer_id = r.customer_id
group by 1, 2, 3;
-- Step 2: Create a Temporary Table
create temporary table total_paid_per_customer as (
select customer_id, sum(amount) as total_paid
from payment p
group by customer_id
);
-- Step 3: Create a CTE and the Customer Summary Report
with customer_summary_report as (
select full_name, email, rental_count, total_paid
from rental_info
join total_paid_per_customer
	on rental_info.customer_id = total_paid_per_customer.customer_id)
select full_name, email, rental_count, total_paid, total_paid/rental_count as avg_payment_per_rental
from customer_summary_report;
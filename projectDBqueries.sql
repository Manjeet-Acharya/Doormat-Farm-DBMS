set echo on;
set timing on;

set linesize 200
set underline =

-- spooling the output and SQL codes to a text file --  
             
spool projectDBqueries.txt;

/* Query 1: 
Find the most popular cuisine-types and arrange them from 
most sold to least sold.
SQL Query: */
SELECT m.cusine_type, count(m.mealkit_id) as Total_Mealkits_Sold
from Spring23_S003_12_Mealkit m, Spring23_S003_12_Subscription_mealkit o2
where m.mealkit_id = o2.mealkit_id
group by m.cusine_type
order by count(m.mealkit_id) DESC;



/*
Query 2:
Find the top 5 mealkits - their cuisine types and mealkit 
descriptions. Include the units sold for each mealkit.
*/
select m.cusine_type as Cuisine_Type, m.mealkit_desc as Mealkit, 
		count(m.mealkit_id) as Units_Sold
from Spring23_S003_12_Mealkit m
Where m.mealkit_id in 
					(Select mealkit_id 
                    from Spring23_S003_12_orders2)
group by m.mealkit_desc, m.cusine_type
order by count(m.mealkit_desc) desc
Fetch first 5 rows only;


/* 
Query 3: Find the customers' favorite vendors
(based on most ordered meal_kit → top 5 vendors) 
*/
Select vendor_id as Vendor, count(mealkit_id) as Mealkits_Sold
From Spring23_S003_12_Mealkit
where mealkit_id in
	(SELECT m.mealkit_id
	from Spring23_S003_12_Mealkit m, Spring23_S003_12_Subscription_mealkit o2
	where m.mealkit_id = o2.mealkit_id)
Group by vendor_id
Order by count(mealkit_id) DESC
Fetch first 5 rows only;



/*
Query 4: 
Calculate the average and maximum distance of deliveries for each warehouse.
*/
SELECT warehouse_id,AVG(Distance_Covered_per_order) as Mean_Distance, MAX(Distance_Covered_per_order) as Maximum_Distance
FROM Spring23_S003_12_warehouse_deliveryVehicle 
GROUP BY ROLLUP(warehouse_id);

-- Find outliers for the above Query.
SELECT warehouse_id,AVG(Distance_Covered_per_order) as Mean_Distance, 
		MAX(Distance_Covered_per_order) as Maximum_Distance,
        NTILE(4) OVER (Order by Distance_Covered_per_order) as Distance_Quartile
FROM Spring23_S003_12_warehouse_deliveryVehicle 
GROUP BY warehouse_id,Distance_Covered_per_order;


/*
Query 5: 
Calculate the average delivery time for each delivery worker
for their respective warehouses. Find 5 good delivery drivers 
(here good means deliver faster) and 5 worst delivery drivers 
(here worst means deliver slower) and the average distance travelled.
*/

/*Best delivery drivers*/
SELECT wd.warehouse_id, dw.worker_ssn,
	AVG(CAST(((TO_DATE(Order_DeliverTS, 'YYYY-MM-DD HH24:MI:SS') - TO_DATE(Order_PickupTS, 'YYYY-MM-DD HH24:MI:SS'))*24*60) AS DECIMAL(10,2))) AS Average_Delivery_Time, 
    AVG(Distance_Covered_per_order) as Mean_Distance
FROM Spring23_S003_12_warehouse_deliveryVehicle wd
JOIN Spring23_S003_12_delivery_worker1 dw ON wd.warehouse_id = dw.warehouse_id
JOIN Spring23_S003_12_Delivery_Order o ON o.Worker_SSN = dw.worker_ssn
GROUP BY wd.warehouse_id, dw.worker_ssn,Distance_Covered_per_order
ORDER BY Average_Delivery_Time ASC
FETCH FIRST 5 ROWS ONLY;

/*Worst delivery drivers*/
SELECT 
  wd.warehouse_id,
  dw.worker_ssn,
  AVG(CAST(((TO_DATE(Order_DeliverTS, 'YYYY-MM-DD HH24:MI:SS') - TO_DATE(Order_PickupTS, 'YYYY-MM-DD HH24:MI:SS'))*24*60) AS DECIMAL(10,2))) AS Average_Delivery_Time, AVG(Distance_Covered_per_order) as Mean_Distance 
FROM Spring23_S003_12_warehouse_deliveryVehicle wd
JOIN Spring23_S003_12_delivery_worker1 dw ON wd.warehouse_id = dw.warehouse_id
JOIN Spring23_S003_12_Delivery_Order o ON o.Worker_SSN = dw.worker_ssn
GROUP BY wd.warehouse_id, dw.worker_ssn,Distance_Covered_per_order
ORDER BY Average_Delivery_Time DESC
FETCH FIRST 5 ROWS ONLY;



/*
Query 6: List all customers who ordered from the warehouse, 
that is located in zipcode = ‘75564’
*/
SELECT c2.customer_id, c2.customer_name
FROM Spring23_S003_12_customer2 c2
JOIN Spring23_S003_12_orders1 co1 ON c2.customer_id = co1.customer_id
JOIN Spring23_S003_12_orders2 o2 ON co1.order_id = o2.order_id
JOIN Spring23_S003_12_mealkit m ON o2.mealkit_id = m.mealkit_id
JOIN Spring23_S003_12_warehouse1 w1 ON m.warehouse_id = w1.warehouse_id
JOIN Spring23_S003_12_warehouse2 w2 ON w1.warehouse_location = w2.warehouse_location
WHERE w2.zipcode like '75564';


/*
Query 7: 
List all the mealkit cuisine types that have ‘Salad’ as their
description.(LIKE Operator)
*/
SELECT Cusine_type, mealkit_desc
FROM Spring23_S003_12_Mealkit
GROUP BY Cusine_type,mealkit_desc
HAVING  Mealkit_Desc LIKE '%salad%';


/*
Query 8: 
Find the most ideal areas to build warehouses. 
This is recognized by the highest subscribing addresses.
*/
select c2.Address, count(o1.customer_id) as Number_Of_Orders
from Spring23_S003_12_Customer2 c2 , Spring23_S003_12_orders1 o1
where c2.customer_id = o1.customer_id
group by c2.Address
order by Number_Of_Orders desc;



/*
Query 9:
Find the vendors who supply all cuisine types
*/
Select Vendor_ID
From Spring23_S003_12_vendor v
Where not exists(
				(Select distinct(Cusine_type)
				From Spring23_S003_12_Mealkit)
                MINUS
                (Select distinct(Cusine_type)
                From Spring23_S003_12_Mealkit vm
                Where v.vendor_id = vm.vendor_id)
                );
                


/*
Query 10: Identifying the most subscribing demographics using customers' 
age, gender, and profession. We can target these demographics during our 
marketing campaigns.
*/
Select 'Age 0 to 23' as Age, age_group_023.Gender Gender,
		age_group_023.occupation as Occupation,
        count(distinct(sub1.customer_id)) as total_subscribers
From Spring23_S003_12_Subscription1 sub1, 
				(select customer_id, customer_name, Dob, occupation, Gender
				from Spring23_S003_12_Customer2
				where Dob like '%2000'or Dob like '%2001'or Dob like '%2002'or
                Dob like'%2003'or Dob like'%2004'or Dob like'%2005'or
                Dob like'%2006'or Dob like '%2007'or Dob like'%2008'or
                Dob like'%2009'or Dob like'%2010'or Dob like'%2011'or
                Dob like'%2012'or Dob like'%2013'or Dob like'%2014'or
                Dob like'%2015'or Dob like'%2016'or Dob like'%2017'or
                Dob like'%2018'or Dob like'%2019'or Dob like'%2020'or
                Dob like'%2021'or Dob like'%2022' or Dob like'%2023') age_group_023
where age_group_023.customer_id = sub1.customer_id
group by cube(age_group_023.Gender, age_group_023.occupation)
union
Select 'Age 23 to 47' as Age, age_group_23_to_47.Gender as Gender,
		age_group_23_to_47.occupation as Occupation,
		count(distinct(sub2.customer_id)) as total_subscribers
From Spring23_S003_12_Subscription1 sub2, 
(select customer_id, customer_name, Dob, occupation, Gender
				from Spring23_S003_12_Customer2
				where Dob like '%1977' or Dob like'%1978' or Dob like'%1979' or
				Dob like '%1980' or Dob like'%1981' or Dob like'%1982'or
				Dob like'%1983' or Dob like'%1984' or Dob like'%1985'or
                Dob like'%1986'or Dob like '%1987'or Dob like'%1988' or
                Dob like '%1989'or Dob like '%1990' or Dob like'%1991' or
                Dob like '%1992' or Dob like'%1993' or Dob like'%1994' or
				Dob like '%1995'or Dob like'%1996'or Dob like'%1997' or
                Dob like '%1998'or Dob like'%1999') age_group_23_to_47
where age_group_23_to_47.customer_id = sub2.customer_id
group by cube(age_group_23_to_47.Gender, age_group_23_to_47.occupation)
order by total_subscribers DESC; 



/*Query 11: 
Find the occupations of the customers (who may or may not have subscription)
who have ordered the most number of mealkits. Include the cuisine type.
*/
CREATE VIEW maxProfessionals AS SELECT c2.gender, c2.occupation, m.cusine_type, count(m.cusine_type) as Total_Orders
FROM Spring23_S003_12_customer2 c2
CROSS JOIN Spring23_S003_12_mealkit m
INNER JOIN Spring23_S003_12_orders1 o1 ON o1.customer_id = c2.customer_id
INNER JOIN Spring23_S003_12_orders2 o2 ON o2.mealkit_id = m.mealkit_id
GROUP BY c2.gender, c2.occupation,m.cusine_type
ORDER BY count(m.cusine_type) desc;


SELECT gender, occupation, cusine_type, max(Total_Orders) from maxProfessionals 
GROUP BY gender, occupation,cusine_type having max(Total_Orders) >=ALL(
select Total_Orders from maxProfessionals 
);

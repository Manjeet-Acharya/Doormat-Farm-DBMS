set echo on;
set timing on;

set linesize 200
set underline =

-- spooling the output and SQL codes to a text file --  
             
spool projectDBcreate.txt;


CREATE TABLE Spring23_S003_12_vendor(
				Vendor_ID varchar(10) NOT NULL,
				Vendor_location char(50) NOT NULL,
				primary key(vendor_id));

CREATE TABLE Spring23_S003_12_Warehouse2(
				warehouse_location char(50) NOT NULL,
				zipcode int NOT NULL,
				primary key(Warehouse_location));

CREATE TABLE Spring23_S003_12_Warehouse1(
				Warehouse_ID varchar(20) NOT NULL,
				warehouse_location char(50) NOT NULL,
				primary key(warehouse_ID),
                Foreign key(Warehouse_location)
                References Spring23_S003_12_Warehouse2(Warehouse_location));

CREATE TABLE Spring23_S003_12_vendor_warehouse(
				Vendor_ID varchar(20),
				Warehouse_ID varchar(20) NOT NULL,
				primary key(vendor_id),
				Foreign key(Vendor_id) 
				references Spring23_S003_12_vendor(Vendor_id),
				Foreign key(Warehouse_ID)
				References Spring23_S003_12_Warehouse1(Warehouse_ID));

CREATE TABLE Spring23_S003_12_Delivery_Worker1(
				Worker_SSN varchar(11) NOT NULL,
				Warehouse_ID varchar(20) NOT NULL,
				DOB varchar(20),
				primary key(Worker_SSN),
                			Foreign key(Warehouse_ID)
                			References Spring23_S003_12_Warehouse1(Warehouse_ID));

CREATE TABLE Spring23_S003_12_warehouse_deliveryVehicle(
				Vehicle_Id varchar(20) NOT NULL,
				Warehouse_ID varchar(20) NOT NULL,
				Distance_Covered_per_order float,
				primary key(Vehicle_Id),
                			Foreign key(Warehouse_ID)
                			References Spring23_S003_12_Warehouse1(Warehouse_ID));

CREATE TABLE Spring23_S003_12_Warehouse_worker(
				Worker_SSN varchar(11) NOT NULL,
				Warehouse_ID varchar(15) NOT NULL,
				Worker_department varchar(20) NOT NULL,
				primary key(Worker_SSN),
                			Foreign key(Warehouse_ID)
               			References Spring23_S003_12_Warehouse1(Warehouse_ID)) ;

CREATE TABLE Spring23_S003_12_Delivery_Worker2(
				Worker_SSN varchar(11) NOT NULL,
				Licence_no VARCHAR(15) NOT NULL,
				Vehicle_ID VARCHAR(15),
				primary key(Worker_SSN));


Create Table Spring23_S003_12_Delivery_Order(
				Worker_SSN varchar(11) not null,
				Order_ID varchar(20) not null, 
				Order_PickupTS varchar(20), 
				Order_DeliverTS varchar(20),
				primary key(Order_ID),
                			Foreign key(Worker_SSN)
                			References Spring23_S003_12_Delivery_Worker2(Worker_SSN));

CREATE TABLE Spring23_S003_12_Delivery_Mealkit(
				Worker_SSN varchar(11)not null,
				mealkit_id varchar(15)not null,
				Primary key (mealkit_id),
                			Foreign key(Worker_SSN)
                			References Spring23_S003_12_Delivery_Worker2(Worker_SSN));


CREATE TABLE Spring23_S003_12_Mealkit(
			Mealkit_id varchar(20) NOT NULL,
			Vendor_ID varchar(20) NOT NULL,
			Warehouse_ID varchar(20) NOT NULL,
			Mealkit varchar(20),
			Cusine_type varchar(20),
			Mealkit_desc char(50),
			primary key(mealkit_id),
			Foreign Key(Vendor_id) 
			References Spring23_S003_12_vendor(Vendor_id),
			Foreign key(Warehouse_id) 
				References Spring23_S003_12_Warehouse1(Warehouse_id));

CREATE TABLE Spring23_S003_12_customer1(
				Customer_id varchar(20) NOT NULL,
				Email varchar(50),
				SubscriptionID varchar(20),
				primary key(customer_id));

    
CREATE TABLE Spring23_S003_12_Customer2(
				Customer_id varchar(20) NOT NULL,
				Customer_Name varchar(20) NOT NULL,
				Dob varchar(20),
				Gender char,
				Address varchar(50),
				Occupation varchar(50),
				primary key(customer_id));

CREATE TABLE Spring23_S003_12_Subscription1(
				Customer_id varchar(20) NOT NULL,
				Subscription_ID varchar(20) NOT NULL,
				primary key(subscription_id),
				Foreign key(Customer_id) 
				references Spring23_S003_12_customer1(Customer_id));


                
CREATE TABLE Spring23_S003_12_Customer_Phoneno(
				Customer_id varchar(20) NOT NULL,
				Phno int NOT NULL,
				primary key(Phno));
                
                
CREATE TABLE Spring23_S003_12_customer_order(
				Customer_id varchar(20) NOT NULL,
				Order_id varchar(20) NOT NULL,
				primary key(order_id));
                

                
                
CREATE TABLE Spring23_S003_12_Subscription2(
				Subscription_ID varchar(20) NOT NULL,
				Subscription_start_Date varchar(20) NOT NULL,
				Subscription_end_Date varchar(20) NOT NULL,
				primary key(subscription_id));
                
                
CREATE TABLE Spring23_S003_12_Subscription_mealkit(
				Subscription_ID varchar(20) NOT NULL,
				mealkit_id varchar(20) NOT NULL,
				primary key(mealkit_id),
				Foreign Key (Subscription_ID) 
                references Spring23_S003_12_Subscription1(Subscription_ID));

     
                
CREATE TABLE Spring23_S003_12_orders1(
				Customer_id varchar(20) NOT NULL,
				Order_timestamp varchar(20) NOT NULL,
				Order_id varchar(20) NOT NULL,
				primary key(order_id),
				Foreign key(Customer_id) 
				references Spring23_S003_12_customer1(Customer_id));

                
CREATE TABLE Spring23_S003_12_orders2(
				Mealkit_id varchar(10) NOT NULL,
				Order_id varchar(15) NOT NULL,
				primary key(mealkit_id),
				Foreign key(Mealkit_id) 
				References Spring23_S003_12_mealkit(Mealkit_id));
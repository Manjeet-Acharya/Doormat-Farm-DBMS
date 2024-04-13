set echo on;
set timing on;


set linesize 200
set underline =

-- spooling the output and SQL codes to a text file --  
             
spool projectDBdrop.txt;


drop table Spring23_S003_12_orders2 purge;

drop table Spring23_S003_12_orders1 purge;

drop table Spring23_S003_12_Subscription_mealkit purge;

drop table Spring23_S003_12_Subscription2 purge;

drop table Spring23_S003_12_customer_order purge;

drop table Spring23_S003_12_Customer_Phoneno purge;

drop table Spring23_S003_12_Subscription1 purge;

drop table Spring23_S003_12_customer2 purge;

drop table Spring23_S003_12_customer1 purge;

drop table Spring23_S003_12_Mealkit purge;

drop table Spring23_S003_12_Delivery_Mealkit purge;

drop table Spring23_S003_12_Delivery_Order purge;

drop table Spring23_S003_12_Delivery_Worker2 purge;

drop table Spring23_S003_12_Warehouse_worker purge;

drop table Spring23_S003_12_Warehouse_deliveryVehicle purge;

drop table Spring23_S003_12_delivery_worker1 purge;

drop table Spring23_S003_12_Vendor_Warehouse purge;

drop table Spring23_S003_12_Warehouse1 purge;

drop table Spring23_S003_12_Warehouse2 purge;

drop table Spring23_S003_12_Vendor purge;
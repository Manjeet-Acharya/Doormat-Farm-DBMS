set echo on;
set timing on;

set linesize 200
set underline =

-- spooling the output and SQL codes to a text file --  
             
spool projectDBupdate.txt;

/*
Update the location of a vendor 'V8-480' who has moved to a different location
*/
update Spring23_S003_12_vendor
set Vendor_location = '848 W Mitchell St.’'
where Vendor_id like 'V8-480';

/*
Update the department of a worker who has moved to a different department
*/

update Spring23_S003_12_Warehouse_worker
set Worker_department= 'Packaging'
where Worker_SSN= '567-49-3403';

/*
we no longer have 'Storage' department so drop the rows that have 
'Storage' as the Worker_department
*/

delete from Spring23_S003_12_Warehouse_worker
where lower(Worker_department) like 'storage';


/*
Update the meal-kit description to chicken and broocli because we no longer 
sell beef
*/
update Spring23_S003_12_Mealkit
set Mealkit_desc = 'chicken and broocli'
where lower(Mealkit_desc) = 'beef and broocli';






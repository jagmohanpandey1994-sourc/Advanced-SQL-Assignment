# Q1. What is a Common Table Expression (CTE), and how does it improve SQL query readability?
with salesCTE as (
select productid, price * Quantity as revenue
from products
)
select productid, revenue
from salesCTE
where revenue > 3000;

# Q2. Why are some views updatable while others are read-only? Explain with an example.
# updatable view 
# single table
# No join,group by, distinct,aggregate functions

create view vw_productprice as
select productid, productname, price
from products;
update vw_productprice
set price = 500
where productid = 1;

# Read - only view
# uses join, group by,count,avg,etc.

create view vw_categorysummary as
select category, count(*) as totalproducts
from products
group by category;

# Q4. What is the purpose of triggers in a database? Mention one use case where a trigger is essential.

after delete 
save deleted data in archive table

#Q6. Write a CTE to calculate the total revenue for each product
#(Revenues = Price × Quantity), and return only products where  revenue > 3000.

with revenueCTE as (
select productid, productname, price * Quantity as revenue
from products
)
select productid, productname, revenue
from revenueCTE
where revenue > 3000;

#Q7. Create a view named that shows:
 #Category, TotalProducts, AveragePrice.
 
 create view vw_categorysummary as
 select category,
 count(*) as totalproducts,
 avg(price) as averageprice
 from products
 group by category;
 
 # Q8. Create an updatable view containing ProductID, ProductName, and Price.
 # Then update the price of ProductID = 1 using the view.
 
 create view vw_productupdate as
select productid, productname, price
from products;
update vw_productupdate
set price = 600
where productid = 1;

# Q9. Create a stored procedure that accepts a category name and returns all products belonging to thatcategory.

create procedure getproductsbycategory
@categoryname varchar(50) as begin
select * from products
where category = @categoryname;
end;
execute getproductsbycategory 'Electronics';

#Q10. Create an AFTER DELETE trigger on the Products table that archives deleted product rows into a new
#table productarchive. The archive should store ProductID, ProductName, Category, Price, and DeletedAttimestamp.

create table productarchive(
productid int,
productname varchar(100),
category varchar(50),
price decimal (10,2),
deletedat datetime
)
create trigger trg_afterdelete_products
on products
after delete
as
begin
insert into productarchive
(productid, productname, category, price, deleteat)
select productid, productname, category, price, getdate()
from deleted;
END;
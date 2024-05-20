#Day 3-1.
select
customerNumber
,customerName
,state
,creditlimit
from classicmodels.customers
where state is not null and creditlimit between 50000 and 100000
order by creditlimit desc ;

#Day 3-2
select
distinct productline
from classicmodels.products
where productline like '%cars';

#Day 4-1
select
ordernumber
,status
,ifnull(comments,'-') as comments
from  classicmodels.orders
where status='shipped';

#Day 4-2
select
employeeNumber
,firstName
,jobTitle
,case 
when jobTitle='President' then 'P'
when jobtitle like '%Sales Manager%'or jobtitle like '%Sale Manager%' then 'SM'
when jobtitle='Sales Rep' then 'SR' 
when jobtitle like 'VP%' then 'VP'
end as Job_Title_Abbr
from classicmodels.employees;

#Day 5-1
select
year(paymentDate) as "Year"
,min(amount) as min_amount
from classicmodels.payments
group by Year
order by Year;

#Day 5-2
select
year(orderdate) as 'Year'
,concat("Q",quarter(orderdate)) as "Quarter"
,count(distinct(customernumber)) as 'Unique Customers'
,count(orderNumber) as total_orders
from classicmodels.orders
group by year,concat("Q",quarter(orderdate));

#Day 5-3
select
date_format(paymentdate,'%b') as 'month'
,concat(round(sum(amount)/1000),"K") as Formatted_amount
from classicmodels.payments
group by month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

#Day 6-1
create table classicmodels.journey
(
Bus_ID INT not null
,Bus_Name varchar(500) not null
,Source_Station varchar(500) not null
,Destination varchar(500) not null
,Email varchar(500) unique
);

#Day 6-2
create table classicmodels.vendor
(
Vendor_ID int primary key
,Name varchar(100) not null
,Email varchar(100) unique
,Country varchar(100) Default "N/A"
);

#Day 6-3
create table classicmodels.movies
(
Movie_ID int primary key
,Name varchar(100) not null
,Release_Year varchar(4) Default "-"
,Cast varchar(100) not null
,Gender enum("Male","Female")
,No_Of_Shows int check(No_Of_Shows>0)
);

#Day 6-4
create table classicmodels.suppliers
(
supplier_id int auto_increment primary key
,supplier_name varchar(100)
,location varchar(100)
);


create table classicmodels.product
(
product_id int auto_increment primary key
,product_name varchar(100) not null unique
,description varchar(1000) 
,supplier_id int
,foreign key(supplier_id) references suppliers(supplier_id)
);

create table classicmodels.Stock
(
id int auto_increment primary key
,product_id int
,foreign key(product_id) references product(product_id)
,balance_stock varchar(100)
);

#Day 7-1
select 
employeeNumber
,concat(firstname," ",lastname) as "Sales Person"
,count(customerNumber) as "Unique Customer"
from classicmodels.employees e inner join classicmodels.customers c on e.employeeNumber=c.salesRepEmployeeNumber
group by concat(firstname," ",lastname),employeeNumber
order by count(customerNumber) desc ;


#Day 7-2
select
c.customerNumber
,c.customerName
,p.productcode
,p.productname
,sum(ord.quantityOrdered) as "Ordered qty"
,sum(p.quantityInStock) as "Total Inventory"
,sum(p.quantityInStock) -sum(ord.quantityOrdered) as "left qty"
from classicmodels.customers c inner join classicmodels.orders o on c.customernumber=o.customernumber
inner join orderdetails ord on o.ordernumber=ord.ordernumber
inner join products p on ord.productcode=p.productcode
group by c.customernumber,p.productcode
order by c.customerNumber; 

#Day 7-3
create table classicmodels.laptop
(
Laptop_Name varchar(100)
);

create table classicmodels.colours
(
Colour_Name varchar(100)
);

insert into classicmodels.laptop
values ("HP"),("Dell");

insert into classicmodels.colours
values ("White"),("Silver"),("Black");

select * 
from laptop cross join colours 
order by laptop_name;

#Day 7-4
create table classicmodels.project
(
EmployeeID int primary key
,FullName varchar(100)
,Gender enum ("Male","Female")
,ManagerID int
);
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select
t1.fullname as "Mamager Name"
,t2.fullname as "Emp Name"
from project T1 inner  join project T2 on T1.employeeid=T2.managerid
order by t2.managerid;


#Day 8
create table classicmodels.facility
(
Facility_ID int
,Name varchar(100)
,State varchar(100)
,Country varchar(100)
);

alter table facility
modify facility_id int primary key auto_increment;

alter table facility
add city varchar(100) not null after name;

describe facility;


#Day 9
create table classicmodels.University
(
ID int primary key
,Name varchar(100)
);

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");

update classicmodels.university
set name= concat(replace(replace("name"," ",""),"University","")," ","University")
where id in (1,2,3);



delete from university
where id in (1,2,3);

INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     ");
              
update classicmodels.university
set name= concat(replace(replace(Name," ",""),"University","")," ","University")
where id in (1,2,3);

select * from university;


#Day-10
create view product_status as
select
year(o.orderdate) as Year
,concat(count(productcode),"(",concat(round((count(productcode)/(select count(productcode) from orderdetails))*100),'%'),")") as Value
from orders o inner join orderdetails od on o.orderNumber=od.ordernumber
group by year
order by count(productCode) desc;

select * from product_status;


#Day 11-1
CALL GetCustomerLevel1(447, @abc); 
SELECT @abc As Customer_Type;

#Day 11-2
CALL Get_country_payments(2003, "France");

#Day 12-1
select
year(orderdate) as 'Year'
,monthname(orderdate) as 'Month'
,count(ordernumber) as 'Total Orders'
,concat(round(((count(ordernumber)-lag(count(ordernumber),1) over())/lag(count(ordernumber),1) over())*100),'%') as "% YOY Change"
from classicmodels.orders
group by year,month;


#Day 12-2
create table classicmodels.emp_udf
(
Emp_ID int PRIMARY KEY auto_increment
,Name varchar(100)
,DOB DATE
);

INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

select *,Calculate_age(DOB) AS 'Age' from emp_udf;

#Day 13-1
select
customernumber
,customername
from classicmodels.customers
where customernumber not in (select customernumber from classicmodels.orders);

#Day 13-2
select
c.customernumber
,c.customername
,count(o.ordernumber) as 'Total Orders'
from classicmodels.customers c left join classicmodels.orders o on c.customernumber=o.customernumber
group by c.customernumber
union 
select
c.customernumber
,c.customername
,count(o.ordernumber) as 'Total Orders'
from classicmodels.customers c right join classicmodels.orders o on c.customernumber=o.customernumber
group by c.customernumber;

#Day 13-3
with od as
(
select
ordernumber
,quantityOrdered
,dense_rank() over(partition by ordernumber order by quantityOrdered desc) as rw
from classicmodels.orderdetails
)
select ordernumber,quantityordered
from od
where rw=2;

#Day 13-4
select
max(total)
,min(total)
from(select ordernumber,count(ordernumber) as Total
from orderdetails
group by ordernumber) as od;

#Day 13-5
select
productline
,count(productline) as Total
from(select productcode,productname,productline,MSRP from products
where MSRP>(select avg(MSRP) from products)) as pl
group by productline
order by total desc;

#Day 14
create table classicmodels.Emp_EH
(
EmpID int primary key auto_increment
,EmpName varchar(100)
,EmailAddress varchar(100) 
);

call InsertEmployeeDetails(1,'Sahana','Sahana@gmail.com');
call InsertEmployeeDetails(2,'Megha','Megha@gmail.com');
call InsertEmployeeDetails(1,'Neha','Neha@gmail.com');

#Day 15
create table classicmodels.Emp_BIT
(
Name varchar(100) not null
,Occupation varchar(100) not null
,Working_date date
,Working_hours int
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

Select * from Emp_BIT;

delimiter //
create trigger before_insert_empworking_hours
before insert on emp_bit for each row
begin
if new.working_hours<0 then set new.working_hours=-(new.working_hours);
end if;
end //

insert into Emp_BIT values('Steven','Actor','2020-10-08', 14);

insert into Emp_BIT values('Tom','Farmer','2020-10-12', -13);

select * from Emp_BIT;

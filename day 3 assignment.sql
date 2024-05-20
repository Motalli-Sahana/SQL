select
customerNumber
,customerName
,state
,creditlimit
from classicmodels.customers
where state is not null and creditlimit between 50000 and 100000
order by creditlimit desc ;

select
distinct productline
from classicmodels.products
where productline like '%cars';
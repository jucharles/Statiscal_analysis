
proc import datafile= '/folders/myfolders/sasuser.v94/base-guide-practice-data/datasets/sales.xlsx'
dbms=xlsx
replace
out=saletable;
getnames=yes;
run;
proc import datafile= '/folders/myfolders/sasuser.v94/base-guide-practice-data/datasets/customers.xlsx'
dbms=xlsx
replace
out=cust;
getnames=yes;
run;
proc import datafile= '/folders/myfolders/sasuser.v94/base-guide-practice-data/datasets/products.xlsx'
dbms=xlsx
replace
out=prod;
getnames=yes;
run;
proc import datafile= '/folders/myfolders/sasuser.v94/base-guide-practice-data/datasets/returns.xlsx'
dbms=xlsx
replace
out=returntable;
getnames=yes;
run;

proc sql;/*merges the tables into one*/
create table Newone as 
select s.*,c.*,p.*
from saletable as s left join cust as c
on s.customer_id=c.id 
left join
prod as p on s.product_id=p.id;
quit;

/*shows the highest sales from customers*/
proc sql;
create table highs as
select customer_name as customers, sum(profit) as profit format=dollar18.
from Newone
group by customer_name
order by profit desc;
quit;

* region distribution;
proc sql;
create table prosale as 
select province, sum(Sales) as sale format=dollar18.
from NewOne
group by province
;quit;
* region proportion;
proc sql;
create table propct as
select province, sale, sale/sum(sale) as pct
from prosale
;quit;

proc chart data=Newone;/*sum of sales by area*/
pie province / 
        discrete
        sumvar=sales;
        
run;

/*highest product return*/
proc sql;
create table returnProd as
select r.*,n.product_name 
from returntable as r
left join NewOne as n
on r.order_id=n.order_id
;quit;

proc sql;
create table groupreturn as
select product_name, count(*) as returns
from returnProd
group by product_name
order by returns descending
;quit;


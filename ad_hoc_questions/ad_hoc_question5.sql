with city_month_revenue as (
select 
c.city_name,
monthname(t.date) as month,
sum(t.fare_amount) as revenue,
sum(sum(t.fare_amount)) over (partition by c.city_id) as total_city_revenue
from fact_trips t
join dim_city c on t.city_id=c.city_id
group by c.city_name, monthname(t.date), c.city_id),
ranked_revenue as(
select 
city_name,
month,
revenue,
total_city_revenue,
rank() over (partition by city_name order by revenue desc ) as revenue_rank
from
city_month_revenue )
select
city_name,
month as highest_revenue_month,
revenue,
ROUND((revenue / total_city_revenue)* 100, 2) as percentage_contribution 
from 
ranked_revenue
where revenue_rank =1 ;

with city_totals as(
	select 
    city_id,
    sum(repeat_passenger_count) as total_repeat_passengers
    from 
    dim_repeat_trip_distribution
    where trip_count in ('2-trips','3-trips','4-trips','5-trips','6-trips','7-trips','8-trips','9-trips','10-trips')
    group by 
    city_id)
select
d.city_id,
c.city_name,
round(sum(case when d.trip_count=2 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `2-trips`,
round(sum(case when d.trip_count=3 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `3-trips`,
round(sum(case when d.trip_count=4 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `4-trips`,
round(sum(case when d.trip_count=5 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `5-trips`,
round(sum(case when d.trip_count=6 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `6-trips`,
round(sum(case when d.trip_count=7 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `7-trips`,
round(sum(case when d.trip_count=8 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `8-trips`,
round(sum(case when d.trip_count=9 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `9-trips`,
round(sum(case when d.trip_count=10 then d.repeat_passenger_count else 0 end)/t.total_repeat_passengers*100, 2) as `10-trips`
from 
dim_repeat_trip_distribution d
join
city_totals t 
on
d.city_id=t.city_id
join 
dim_city c
on 
d.city_id=c.city_id
where 
d.trip_count in ('2-trips','3-trips','4-trips','5-trips','6-trips','7-trips','8-trips','9-trips','10-trips')
group by 
d.city_id,c.city_name
order by 
c.city_name
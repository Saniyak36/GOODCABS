select 
	`dim_city`.`city_name`,
	count(`fact_trips`.`trip_id`)as `total_trips`,
    avg(`fact_trips`.`fare_amount`/`fact_trips`.`distance_travelled_km`) as `avg_fare_per_km`,
    round(avg(`fact_trips`.`fare_amount`), 2) as `avg_fare_per_trip`,
    (count(`fact_trips`.`trip_id`) * 100.0/(select count(*) from `fact_trips`)) as `%_contribution_to_total_trips`
from 
`dim_city`
join 
`fact_trips` on `dim_city`.`city_id`=`fact_trips`.`city_id`
group by 
`dim_city`.`city_name`;
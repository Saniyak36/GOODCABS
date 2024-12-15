SELECT 
    d.city_name,
    round(AVG(f.fare_amount),2) AS AverageFarePerTrip,
    round(AVG(f.distance_travelled_km),2) AS AverageDistance
FROM 
    fact_trips f
join dim_city d on f.city_id=d.city_id
GROUP BY 
    d.city_id
order by 
AverageFarePerTrip desc;
SELECT 
    d.city_name,
    f.passenger_type,
    round(AVG(f.passenger_rating),2) AS AveragePassengerRating,
    round(AVG(f.driver_rating),2) AS AverageDriverRating
FROM 
    fact_trips f
join dim_city d on f.city_id=d.city_id
GROUP BY 
    d.city_id,
    f.passenger_type
order by 
AveragePassengerRating desc;

SELECT 
    dm.city_name,
    monthname(ft.`date`) as month_name,
    COUNT(ft.trip_id) AS actual_trips,
    targets_db.monthly_target_trips.total_target_trips  AS target_trip_count, -- Handle missing target values
    CASE 
        WHEN COUNT(ft.trip_id) > COALESCE(targets_db.monthly_target_trips.total_target_trips, 0) THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance,
    ROUND(((COUNT(ft.trip_id) - COALESCE(targets_db.monthly_target_trips.total_target_trips, 0)) * 100.0 / 
           NULLIF(targets_db.monthly_target_trips.total_target_trips, 0)), 2) AS `%_difference`
FROM 
    trips_db.fact_trips ft
LEFT JOIN 
    targets_db.monthly_target_trips ON ft.city_id = targets_db.monthly_target_trips.city_id AND monthname(ft.date) = monthname(targets_db.monthly_target_trips.month)
JOIN 
    trips_db.dim_city dm ON ft.city_id = dm.city_id
GROUP BY 
    dm.city_name, monthname(ft.date), targets_db.monthly_target_trips.total_target_trips;


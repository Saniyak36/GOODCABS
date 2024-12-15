SELECT
    d.city_name,
    monthname(t.month) as month,
    new_passengers AS actual_new_passengers,
    t.target_new_passengers,
    ROUND((SUM(f.new_passengers) * 100.0 / sum(t.target_new_passengers)), 2) AS new_passenger_achievement_percentage,
    ct.target_avg_passenger_rating,
    ROUND(AVG(ft.passenger_rating), 2) AS actual_avg_passenger_rating,
    ROUND((AVG(ft.passenger_rating) - ct.target_avg_passenger_rating), 2) AS rating_difference
FROM
    dim_city d
JOIN
    fact_passenger_summary f ON d.city_id = f.city_id
JOIN
    targets_db.monthly_target_new_passengers t ON d.city_id = t.city_id AND f.month = t.month
JOIN
    fact_trips ft ON d.city_id = ft.city_id AND f.month = DATE_FORMAT(ft.date, '%Y-%m-01')
join 
	targets_db.city_target_passenger_rating ct on d.city_id=ct.city_id
GROUP BY
    d.city_name, month, t.target_new_passengers, ct.target_avg_passenger_rating,new_passengers;

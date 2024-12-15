WITH MonthlyRates AS (
    SELECT 
        fps.city_id,
        c.city_name,
        monthname(fps.month) as month,
        fps.total_passengers,
        fps.repeat_passengers,
        ROUND((fps.repeat_passengers / fps.total_passengers) * 100, 2) AS monthly_repeat_passenger_rate_percentage
    FROM 
        fact_passenger_summary fps
    JOIN 
        dim_city c ON fps.city_id = c.city_id
),
CityWideRates AS (
    SELECT 
        fps.city_id,
        c.city_name,
        ROUND((SUM(fps.repeat_passengers) / SUM(fps.total_passengers)) * 100, 2) AS city_repeat_passenger_rate_percentage
    FROM 
        fact_passenger_summary fps
    JOIN 
        dim_city c ON fps.city_id = c.city_id
    GROUP BY 
        fps.city_id, c.city_name
)
SELECT 
    m.city_name,
    m.month,
    m.total_passengers,
    m.repeat_passengers,
    m.monthly_repeat_passenger_rate_percentage,
    cwr.city_repeat_passenger_rate_percentage
FROM 
    MonthlyRates m
JOIN 
    CityWideRates cwr ON m.city_id = cwr.city_id;


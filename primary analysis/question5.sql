with TripDate as (
select
dd.day_type,
count(ft.trip_id) as totalTrips,
dm.city_name as City
from 
fact_trips ft
join dim_date dd on ft.date=dd.date
join dim_city dm on ft.city_id=dm.city_id
WHERE 
ft.date >= CURRENT_DATE - INTERVAL 6 MONTH
group by
dd.day_type,dm.city_name),

TripSummary AS (
    SELECT 
        City,
        SUM(CASE WHEN day_type = 'Weekend' THEN TotalTrips ELSE 0 END) AS WeekendTrips,
        SUM(CASE WHEN day_type = 'Weekday' THEN TotalTrips ELSE 0 END) AS WeekdayTrips
    FROM 
        TripDate
    GROUP BY 
        City
)
SELECT 
    City,
    WeekendTrips,
    WeekdayTrips,
    CASE 
        WHEN WeekendTrips > WeekdayTrips THEN 'Weekend   Preference'
        ELSE 'Weekday   Preference'
    END AS Preference
FROM 
    TripSummary
ORDER BY 
    City;
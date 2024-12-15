with monthly_trips as (
select 
city_id as city,
monthname(date) as TripMonth,
count(trip_id) as Totaltrips
from 
fact_trips
group by 
city_id,monthname(date)),

maxTrips as(
select
city,
TripMonth,
Totaltrips
from 
monthly_trips 
WHERE 
        Totaltrips = (
            SELECT MAX(Totaltrips) 
            FROM monthly_trips AS sub 
            WHERE sub.city = monthly_trips.City
        )
),
minTrips as(
select
city,
TripMonth,
Totaltrips
from 
monthly_trips 
WHERE 
        Totaltrips = (
            SELECT MIN(Totaltrips) 
            FROM monthly_trips AS sub 
            WHERE sub.city = monthly_trips.city
        )
)

SELECT 
    maxTrips.City,
    maxTrips.TripMonth AS MonthWithMaxTrips,
    maxTrips.Totaltrips AS MaxTrips,
    minTrips.TripMonth AS MonthWithMinTrips,
    minTrips.Totaltrips AS MinTrips
FROM 
    MaxTrips
JOIN 
    MinTrips
ON 
    maxTrips.City = minTrips.City
ORDER BY 
    maxTrips.City;
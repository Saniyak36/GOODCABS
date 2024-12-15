WITH RepeatTripAnalysis AS (
    SELECT
        d.city_name,
        rtd.trip_count,
        SUM(rtd.repeat_passenger_count) AS total_repeat_passengers
    FROM
        dim_city d
    JOIN
        dim_repeat_trip_distribution rtd ON d.city_id = rtd.city_id
    GROUP BY
        d.city_name, rtd.trip_count
),
CityTotalRepeat AS (
    SELECT
        city_name,
        SUM(total_repeat_passengers) AS city_total_repeat_passengers
    FROM
        RepeatTripAnalysis
    GROUP BY
        city_name
)
SELECT
    rta.city_name,
    rta.trip_count,
    rta.total_repeat_passengers,
    ROUND((rta.total_repeat_passengers * 100.0 / ctr.city_total_repeat_passengers), 2) AS percentage_contribution
FROM
    RepeatTripAnalysis rta
JOIN
    CityTotalRepeat ctr ON rta.city_name = ctr.city_name
group by
rta.city_name,rta.trip_count
ORDER BY
    percentage_contribution desc;

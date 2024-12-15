WITH RepeatPassengerRate AS (
    SELECT
        d.city_name,
        monthname(rtd.month) as month,
        SUM(rtd.repeat_passenger_count) AS total_repeat_passengers,
        SUM(fps.total_passengers) AS total_passengers,
        ROUND((SUM(rtd.repeat_passenger_count) * 100.0 / SUM(fps.total_passengers)), 2) AS repeat_passenger_rate
    FROM
        dim_city d
    JOIN
        dim_repeat_trip_distribution rtd ON d.city_id = rtd.city_id
    JOIN
        fact_passenger_summary fps ON d.city_id = fps.city_id AND rtd.month = fps.month
    GROUP BY
        d.city_name, month
),
RankedRPR AS (
    SELECT
        city_name,
        month,
        repeat_passenger_rate,
        RANK() OVER (PARTITION BY month ORDER BY repeat_passenger_rate DESC) AS rank_highest,
        RANK() OVER (PARTITION BY month ORDER BY repeat_passenger_rate ASC) AS rank_lowest
    FROM
        RepeatPassengerRate
),
FilteredRPR AS (
    SELECT
        city_name,
        month,
        repeat_passenger_rate
    FROM
        RankedRPR
    WHERE
        rank_highest <= 2 OR rank_lowest <= 2
)
SELECT
    city_name,
    month,
    repeat_passenger_rate
FROM
    FilteredRPR
ORDER BY
    repeat_passenger_rate desc;

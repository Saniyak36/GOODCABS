WITH city_aggregates AS (
    SELECT
        d.city_id,
        c.city_name,
        SUM(d.new_passengers) AS total_new_passengers
    FROM
        fact_passenger_summary d
    JOIN
        dim_city c
    ON
        d.city_id = c.city_id
    GROUP BY
        d.city_id, c.city_name
),
ranked_cities AS (
    SELECT
        city_id,
        city_name,
        total_new_passengers,
        RANK() OVER (ORDER BY total_new_passengers DESC) AS rank_desc,
        RANK() OVER (ORDER BY total_new_passengers ASC) AS rank_asc
    FROM
        city_aggregates
),
filtered_cities AS (
    SELECT
        city_id,
        city_name,
        total_new_passengers,
        CASE 
            WHEN rank_desc <= 3 THEN 'TOP 3'
            WHEN rank_asc <= 3 THEN 'BOTTOM 3'
        END AS city_category
    FROM
        ranked_cities
    WHERE rank_desc <= 3 OR rank_asc <= 3
)
SELECT 
    city_id,
    city_name,
    city_category,
    total_new_passengers
FROM 
    filtered_cities
ORDER BY 
    city_category, total_new_passengers DESC;

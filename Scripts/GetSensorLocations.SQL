SELECT
  name,
  reading,
  st_x(st_astext(geom)) AS longitude,
  st_y(st_astext(geom)) AS latitude,
  geom
FROM 
  sensorlocations sl 
  INNER JOIN 
    (
    SELECT 
      info -> 'name' AS name, 
      info -> 'vars' as reading
    FROM
      sensors
    WHERE
      info -> 'status' = 'active' AND
      info -> 'type' = 'Air Quality'
    ) AS si USING(name) 
WHERE
  sl.geom IS NOT NULL

-- INNER JOIN
SELECT d.district_name, z.zone_name, c.collection_date, c.waste_kg
FROM collections c
INNER JOIN zones z ON c.zone_id = z.zone_id
INNER JOIN districts d ON z.district_id = d.district_id;

-- LEFT JOIN
SELECT d.district_name
FROM districts d
LEFT JOIN zones z ON d.district_id = z.district_id
LEFT JOIN collections c ON z.zone_id = c.zone_id
WHERE c.collection_id IS NULL;

-- RIGHT JOIN
SELECT z.zone_name
FROM collections c
RIGHT JOIN zones z ON c.zone_id = z.zone_id
WHERE c.collection_id IS NULL;

-- FULL OUTER JOIN
SELECT d.district_name, z.zone_name
FROM districts d
FULL OUTER JOIN zones z
ON d.district_id = z.district_id;

-- SELF JOIN
SELECT a.zone_name AS zone_1, b.zone_name AS zone_2, d.district_name
FROM zones a
JOIN zones b ON a.district_id = b.district_id
JOIN districts d ON a.district_id = d.district_id
WHERE a.zone_id <> b.zone_id;

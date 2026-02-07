sql/schema.sql
-- Create districts table
CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    district_name VARCHAR(100) NOT NULL,
    population INT NOT NULL
);

-- Create zones table
CREATE TABLE zones (
    zone_id SERIAL PRIMARY KEY,
    district_id INT REFERENCES districts(district_id),
    zone_name VARCHAR(100) NOT NULL
);

-- Create collections table
CREATE TABLE collections (
    collection_id SERIAL PRIMARY KEY,
    zone_id INT REFERENCES zones(zone_id),
    collection_date DATE NOT NULL,
    waste_kg DECIMAL(10,2) NOT NULL,
    contractor VARCHAR(100)
);
 

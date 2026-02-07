INSERT INTO districts (district_name, population) VALUES
('Gasabo', 900000),
('Kicukiro', 700000),
('Nyarugenge', 600000),
('Bugesera', 450000);

INSERT INTO zones (district_id, zone_name) VALUES
(1, 'Kimironko'),
(1, 'Kacyiru'),
(2, 'Gikondo'),
(2, 'Kanombe'),
(3, 'Nyamirambo'),
(4, 'Ruhuha');

INSERT INTO collections (zone_id, collection_date, waste_kg, contractor) VALUES
(1, '2025-01-05', 1200, 'CleanCity Ltd'),
(1, '2025-02-05', 1350, 'CleanCity Ltd'),
(1, '2025-03-05', 1500, 'CleanCity Ltd'),
(2, '2025-01-10', 900, 'EcoWaste'),
(2, '2025-02-10', 950, 'EcoWaste'),
(3, '2025-01-08', 1100, 'GreenMove'),
(3, '2025-02-08', 1250, 'GreenMove'),
(4, '2025-03-12', 800, 'EcoWaste'),
(5, '2025-01-15', 1600, 'CleanCity Ltd'),
(5, '2025-02-15', 1700, 'CleanCity Ltd');

-- Dashboard DB
CREATE TABLE public.shelters (
	id SERIAL PRIMARY KEY,
	city VARCHAR(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
	type VARCHAR(255) NOT NULL,
	capacity INT NOT NULL
);

CREATE TABLE public.parking_lots (
	id SERIAL PRIMARY KEY,
	city VARCHAR(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
	car_spaces INT NOT NULL,
	scooter_spaces INT NOT NULL
);

-- Component
INSERT INTO public.components 
( index, name )
VALUES ('emergency_shelter', '緊急應變設施')

-- Component Maps
INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('metrotaipei_emergency_shelter', '緊急應變設施', 'circle', 'geojson', 'big', null, '{"circle-color": "#BBFF66"}', '[{"key": "name", "name": "名稱"}, {"key": "type", "name": "類型"}]');

-- Metro Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'emergency_shelter', null, '{?}', null, 'static', 
	null, 0, null, '緊急應變避難所', '緊急應變避難所', '緊急應變避難所', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'SELECT ''避難場所'' as x_axis, (
SELECT COUNT(*) FROM shelters
) as data
UNION
SELECT ''停車場'' as x_axis, (
SELECT COUNT(*) FROM parking_lots
) as data;', null, 'metrotaipei');	

-- Component Charts
INSERT INTO public.component_charts
( index, color, types, unit)
VALUES
( 'emergency_shelter', '{#FF6666}', '{BarChart}', '處');

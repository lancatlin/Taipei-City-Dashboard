-- Component Data
INSERT INTO components (index, name) 
VALUES ('fire_station_distribution', '消防局分布圖');

-- Component Maps
INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('taipei_fire_stations', '消防局分布圖', 'circle', 'geojson', 'big', null, '{"circle-color": "#FF6666"}', '[{"key": "name", "name": "名稱"}]');

-- Component Maps
INSERT INTO public.component_maps(
	index, title, type, source, size, icon, paint, property)
	VALUES ('metrotaipei_fire_stations', '消防局分布圖', 'circle', 'geojson', 'big', null, '{"circle-color": "#FF6666"}', '[{"key": "name", "name": "名稱"}]');

-- Taipei City	
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_station_distribution', null, '{?}', null, 'static', 
	null, 0, null, '消防局', '消防局分布圖', '消防局分布圖', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'SELECT ''消防局'' AS xaxis, 250 AS data;', null, 'taipei');	

-- Metro Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_station_distribution', null, '{?}', null, 'static', 
	null, 0, null, '消防局', '消防局分布圖', '消防局分布圖', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'SELECT ''消防局'' AS xaxis, 250 AS data;', null, 'metrotaipei');	

-- Component Charts
INSERT INTO public.component_charts
( index, color, types, unit)
VALUES
( 'fire_station_distribution', '{#FF6666}', '{BarChart}', '處');
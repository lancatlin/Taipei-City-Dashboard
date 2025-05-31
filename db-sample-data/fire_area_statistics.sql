CREATE TABLE fire_area_statistics (
  id          SERIAL          PRIMARY KEY,
  city        VARCHAR(100)    NOT NULL,
  area        VARCHAR(100)    NOT NULL,
  time        TIMESTAMP       NOT NULL,
  total       INTEGER         NOT NULL,
  livingroom  INTEGER         NOT NULL,
  bedroom     INTEGER         NOT NULL,
  study       INTEGER         NOT NULL,
  kitchen     INTEGER         NOT NULL,
  bathroom    INTEGER         NOT NULL,
  shrine      INTEGER         NOT NULL,
  balcony     INTEGER         NOT NULL,
  courtyard   INTEGER         NOT NULL,
  UNIQUE (city, area, time)
);

INSERT INTO fire_area_statistics
  (city, area, time, total,
   livingroom, bedroom, study,
   kitchen, bathroom, shrine, balcony, courtyard)
VALUES

-- Manager Data
INSERT INTO components (index, name) 
VALUES ('fire_district_stats', '行政區起火統計');

-- Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_district_stats', null, null, null, 'static', 
	null, 0, null, '行政區', '行政區起火統計', '行政區起火統計', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'SELECT "area" as x_axis, total as data FROM public.fire_area_statistics WHERE city = ''taipei'' AND time = ''2025-04-01'' ', 
	null, 'taipei');

-- Metro Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_district_stats', null, null, null, 'static', 
	null, 0, null, '行政區', '行政區起火統計', '行政區起火統計', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'SELECT "area" as x_axis, total as data FROM public.fire_area_statistics WHERE time = ''2025-04-01''', 
	null, 'metrotaipei');

-- Component Charts
INSERT INTO public.component_charts
( index, color, types, unit)
VALUES
( 'fire_district_stats', '{#FFFF00}', '{DistrictChart}', '件');

-- Query 
-- 1) Compute each column's total in a subquery named "totals"
-- 2) CROSS JOIN LATERAL (VALUES ...) to turn the columns into (x_axis, data) rows

SELECT
  x_axis,
  data
FROM (
  SELECT
    SUM(livingroom)  AS livingroom,
    SUM(bedroom)     AS bedroom,
    SUM(study)       AS study,
    SUM(kitchen)     AS kitchen,
    SUM(bathroom)    AS bathroom,
    SUM(shrine)      AS shrine,
    SUM(balcony)     AS balcony,
    SUM(courtyard)   AS courtyard,
    SUM(restaurant)  AS restaurant
  FROM fire_area_statistics
  WHERE time = '2025-05-01'
) AS totals
CROSS JOIN LATERAL (
  VALUES
    ('客廳',  totals.livingroom),
    ('臥室',     totals.bedroom),
    ('書房',       totals.study),
    ('廚房',     totals.kitchen),
    ('浴廁',    totals.bathroom),
    ('神龕',      totals.shrine),
    ('陽台',     totals.balcony),
    ('庭院',   totals.courtyard)
) AS unpivot(x_axis, data);

-- Manager Data
INSERT INTO components (index, name) 
VALUES ('fire_area_distribution', '起火區域分布圖');

-- Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_area_distribution', null, null, null, 'static', 
	null, 0, null, '起火區域', '起火區域分布圖', '起火區域分布圖', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'
SELECT
  x_axis,
  data
FROM (
  SELECT
    SUM(livingroom)  AS livingroom,
    SUM(bedroom)     AS bedroom,
    SUM(study)       AS study,
    SUM(kitchen)     AS kitchen,
    SUM(bathroom)    AS bathroom,
    SUM(shrine)      AS shrine,
    SUM(balcony)     AS balcony,
    SUM(courtyard)   AS courtyard
  FROM fire_area_statistics
  WHERE time = ''2025-04-01'' AND city = ''taipei''
) AS totals
CROSS JOIN LATERAL (
  VALUES
    (''客廳'',  totals.livingroom),
    (''臥室'',     totals.bedroom),
    (''書房'',       totals.study),
    (''廚房'',     totals.kitchen),
    (''浴廁'',    totals.bathroom),
    (''神龕'',      totals.shrine),
    (''陽台'',     totals.balcony),
    (''庭院'',   totals.courtyard)
) AS unpivot(x_axis, data);
	', 
	null, 'taipei');

-- Metro Taipei City
INSERT INTO public.query_charts 
(
	index, history_config, map_config_ids, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history, city
)
VALUES (
	'fire_area_distribution', null, null, null, 'static', 
	null, 0, null, '起火區域', '起火區域分布圖', '起火區域分布圖', 'nah', '{}', 
	null, '2025-05-27', '2025-05-27', 'two_d', 
	'
SELECT
  x_axis,
  data
FROM (
  SELECT
    SUM(livingroom)  AS livingroom,
    SUM(bedroom)     AS bedroom,
    SUM(study)       AS study,
    SUM(kitchen)     AS kitchen,
    SUM(bathroom)    AS bathroom,
    SUM(shrine)      AS shrine,
    SUM(balcony)     AS balcony,
    SUM(courtyard)   AS courtyard
  FROM fire_area_statistics
  WHERE time = ''2025-04-01''
) AS totals
CROSS JOIN LATERAL (
  VALUES
    (''客廳'',  totals.livingroom),
    (''臥室'',     totals.bedroom),
    (''書房'',       totals.study),
    (''廚房'',     totals.kitchen),
    (''浴廁'',    totals.bathroom),
    (''神龕'',      totals.shrine),
    (''陽台'',     totals.balcony),
    (''庭院'',   totals.courtyard)
) AS unpivot(x_axis, data);
	', 
	null, 'metrotaipei');

-- Component Charts
INSERT INTO public.component_charts
( index, color, types, unit)
VALUES
( 'fire_area_distribution', '{#899FFE}', '{TreemapChart}', '件');

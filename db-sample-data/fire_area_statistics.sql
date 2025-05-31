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
  -- Taipei City (12 districts)
  ('taipei', '中正區', '2025-05-01', 25,  2,3,1, 3,0,4,4,3),
  ('taipei', '大同區', '2025-05-01', 10,  4,1,2, 0,0,1,2,0),
  ('taipei', '中山區', '2025-05-01', 26,  3,3,2, 4,0,4,5,4),
  ('taipei', '松山區', '2025-05-01', 31,  3,1,5, 0,4,5,5,5),
  ('taipei', '大安區', '2025-05-01', 13,  1,3,2, 3,1,0,0,0),
  ('taipei', '萬華區', '2025-05-01', 25,  4,2,0, 2,1,5,3,3),
  ('taipei', '信義區', '2025-05-01', 22,  1,1,5, 5,5,1,4,0),
  ('taipei', '士林區', '2025-05-01', 26,  3,5,2, 0,1,3,5,4),
  ('taipei', '北投區', '2025-05-01', 22,  1,3,1, 5,0,3,4,0),
  ('taipei', '內湖區', '2025-05-01', 24,  3,4,5, 4,2,2,0,4),
  ('taipei', '南港區', '2025-05-01', 23,  4,0,0, 5,5,0,4,0),
  ('taipei', '文山區', '2025-05-01', 21,  5,3,4, 0,1,0,2,3),

  -- New Taipei City (29 districts)
  ('newtaipei', '板橋區', '2025-05-01', 20,  2,0,3, 0,5,4,0,2),
  ('newtaipei', '汐止區', '2025-05-01', 21,  0,4,3, 5,1,0,4,2),
  ('newtaipei', '深坑區', '2025-05-01', 22,  0,2,4, 4,0,3,1,3),
  ('newtaipei', '石碇區', '2025-05-01', 18,  1,2,1, 2,0,2,3,3),
  ('newtaipei', '瑞芳區', '2025-05-01', 25,  2,3,3, 1,0,5,3,4),
  ('newtaipei', '平溪區', '2025-05-01', 19,  0,1,2, 2,1,2,3,5),
  ('newtaipei', '雙溪區', '2025-05-01', 17,  1,0,3, 0,2,1,4,4),
  ('newtaipei', '貢寮區', '2025-05-01',  9,  0,0,1, 0,0,2,2,3),
  ('newtaipei', '新店區', '2025-05-01', 24,  3,2,4, 2,1,3,2,4),
  ('newtaipei', '坪林區', '2025-05-01', 11,  0,1,0, 1,0,1,2,4),
  ('newtaipei', '烏來區', '2025-05-01', 16,  1,1,2, 0,1,2,3,5),
  ('newtaipei', '永和區', '2025-05-01', 27,  4,3,5, 3,2,4,1,3),
  ('newtaipei', '中和區', '2025-05-01', 29,  5,4,3, 4,1,2,2,5),
  ('newtaipei', '土城區', '2025-05-01', 22,  2,2,1, 3,0,4,2,5),
  ('newtaipei', '三峽區', '2025-05-01', 24,  4,2,3, 4,2,5,2,0),
  ('newtaipei', '樹林區', '2025-05-01', 26,  3,3,3, 1,4,2,1,5),
  ('newtaipei', '鶯歌區', '2025-05-01', 27,  4,5,1, 1,5,5,2,2),
  ('newtaipei', '三重區', '2025-05-01', 31,  0,4,0, 5,5,3,5,5),
  ('newtaipei', '新莊區', '2025-05-01', 23,  5,5,1, 2,0,5,0,5),
  ('newtaipei', '泰山區', '2025-05-01', 19,  0,0,2, 5,5,2,1,3),
  ('newtaipei', '林口區', '2025-05-01', 12,  0,1,4, 0,2,3,2,0),
  ('newtaipei', '蘆洲區', '2025-05-01', 17,  0,4,0, 3,3,1,1,0),
  ('newtaipei', '五股區', '2025-05-01', 21,  5,2,1, 3,0,3,2,1),
  ('newtaipei', '八里區', '2025-05-01', 22,  1,1,5, 0,5,1,2,5),
  ('newtaipei', '淡水區', '2025-05-01', 20,  4,2,2, 0,2,4,0,3),
  ('newtaipei', '三芝區', '2025-05-01', 23,  1,4,1, 3,3,1,5,2),
  ('newtaipei', '石門區', '2025-05-01', 13,  0,0,3, 2,1,1,0,1),
  ('newtaipei', '金山區', '2025-05-01', 18,  2,1,1, 0,1,3,5,4),
  ('newtaipei', '萬里區', '2025-05-01', 23,  1,3,5, 2,2,2,4,4);

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
	'SELECT "area" as x_axis, total as data FROM public.fire_area_statistics WHERE city = ''taipei'' ', 
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
	'SELECT "area" as x_axis, total as data FROM public.fire_area_statistics', 
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
    ('livingroom',  totals.livingroom),
    ('bedroom',     totals.bedroom),
    ('study',       totals.study),
    ('kitchen',     totals.kitchen),
    ('bathroom',    totals.bathroom),
    ('shrine',      totals.shrine),
    ('balcony',     totals.balcony),
    ('courtyard',   totals.courtyard),
    ('restaurant',  totals.restaurant)
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
  WHERE time = ''2025-05-01'' AND city = ''taipei''
) AS totals
CROSS JOIN LATERAL (
  VALUES
    (''livingroom'',  totals.livingroom),
    (''bedroom'',     totals.bedroom),
    (''study'',       totals.study),
    (''kitchen'',     totals.kitchen),
    (''bathroom'',    totals.bathroom),
    (''shrine'',      totals.shrine),
    (''balcony'',     totals.balcony),
    (''courtyard'',   totals.courtyard)
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
  WHERE time = ''2025-05-01''
) AS totals
CROSS JOIN LATERAL (
  VALUES
    (''livingroom'',  totals.livingroom),
    (''bedroom'',     totals.bedroom),
    (''study'',       totals.study),
    (''kitchen'',     totals.kitchen),
    (''bathroom'',    totals.bathroom),
    (''shrine'',      totals.shrine),
    (''balcony'',     totals.balcony),
    (''courtyard'',   totals.courtyard)
) AS unpivot(x_axis, data);
	', 
	null, 'metrotaipei');

-- Component Charts
INSERT INTO public.component_charts
( index, color, types, unit)
VALUES
( 'fire_area_distribution', '{#899FFE}', '{TreemapChart}', '件');

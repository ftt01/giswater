/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_edit_rtc_hydro_data_x_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_rtc_hydro_data_x_connec AS
SELECT
ext_rtc_hydrometer_x_data.id,
rtc_hydrometer_x_connec.connec_id,
ext_rtc_hydrometer_x_data.hydrometer_id,
ext_rtc_hydrometer.cat_hydrometer_id,
ext_cat_hydrometer.madeby,
ext_cat_hydrometer.class,
ext_rtc_hydrometer_x_data.cat_period_id,
sum,
custom_sum
FROM ext_rtc_hydrometer_x_data
JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer_x_data.hydrometer_id::text=ext_rtc_hydrometer.hydrometer_id::text
LEFT JOIN ext_cat_hydrometer ON ext_cat_hydrometer.id::text = ext_rtc_hydrometer.cat_hydrometer_id::text
JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id=ext_rtc_hydrometer_x_data.hydrometer_id;


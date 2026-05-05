create database baitap3;

use baitap3;


select driver_id, driver_name, status, trust_score, distance_km
from Drivers
where status = 'AVAILABLE'
and trust_score > 80
order by distance_km asc,
		trust_score desc;
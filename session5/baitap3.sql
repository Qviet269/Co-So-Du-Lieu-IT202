create database baitap3;

use baitap3;


select driver_id, driver_name, status, trust_score, distance_km
from Drivers
where status = 'AVAILABLE'
and trust_score > 80
order by distance_km asc,
		trust_score desc;
	
-- Nếu min_trust_score = -10, điều kiện trust_score >= -10 sẽ luôn đúng (vì trust_score thường từ 0-100). 
-- Hệ thống sẽ lấy hết tài xế AVAILABLE kể cả những người rất tệ.
insert into zzz_ctlog_c_uid select * from wd.zzz_ctlog_c_uid
where time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");

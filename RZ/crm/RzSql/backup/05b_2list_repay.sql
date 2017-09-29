insert into 05b_2list_repay select * from wd.05b_2list_repay
where time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");

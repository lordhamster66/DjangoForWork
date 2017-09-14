insert into rz_borrow_tender_8 select * from new_wd.rz_borrow_tender_8
where create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and create_time <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");

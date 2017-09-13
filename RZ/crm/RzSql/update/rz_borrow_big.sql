UPDATE rzjf_bi.rz_borrow_big a,new_wd.rz_borrow_big b
set a.status=b.status,
a.scales=b.scales,
a.full_time=b.full_time
where a.id=b.id
and a.create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 10 DAY),"%Y-%m-%d 23:30:00")
and a.create_time <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");
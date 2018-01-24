UPDATE rzjf_bi.rz_borrow a,new_wd.rz_borrow b
set a.status=b.status,
a.scales=b.scales,
a.full_time=b.full_time,
a.category=b.category
where a.id=b.id
and a.create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 30 DAY),"%Y-%m-%d 23:59:59")
and a.create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");
UPDATE rzjf_bi.05b_0base a,rz_borrow.rz_borrow b
set a.status=b.status,
a.reverify_time=b.full_time
where a.bid=b.id
and a.time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 30 DAY),"%Y-%m-%d 23:59:59")
and a.time_h <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");
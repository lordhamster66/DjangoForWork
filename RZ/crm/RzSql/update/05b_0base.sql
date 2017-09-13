UPDATE rzjf_bi.05b_0base a,wd.05b_0base b
set a.status=b.status,
a.reverify_time=b.reverify_time
where a.bid=b.bid
and a.time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 10 DAY),"%Y-%m-%d 23:30:00")
and a.time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");


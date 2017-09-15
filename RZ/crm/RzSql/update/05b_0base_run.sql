UPDATE rzjf_bi.05b_0base_run a,wd.05b_0base_run b
set a.tender_num=b.tender_num,
a.tender_times=b.tender_times,
a.borrow_account_yes=b.borrow_account_yes,
a.borrow_account_wait=b.borrow_account_wait,
a.borrow_account_scale=b.borrow_account_scale
where a.bid=b.bid
and a.time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 30 DAY),"%Y-%m-%d 23:30:00")
and a.time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");
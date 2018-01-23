UPDATE rzjf_bi.05b_0base_run a,rz_borrow.rz_borrow b
set a.borrow_account_yes=b.amount,
a.borrow_account_wait=b.amount-b.amount,
a.borrow_account_scale=if(b.full_time="0000-00-00 00:00:00",'0','100')
where a.bid=b.id
and a.time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 30 DAY),"%Y-%m-%d 23:30:00")
and a.time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");
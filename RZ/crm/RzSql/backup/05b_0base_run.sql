# 05b_0base_run
insert into 05b_0base_run
(`bid`, `account`, `tender_num`, `tender_times`, `hits`, `time_h`, `borrow_account_yes`,
`borrow_account_wait`, `borrow_account_scale`, `borrow_times`, `dj_bzj`, `dj_sq`, `attrv`, `autorepay`)
select
id											                       `bid`,
amount									                       `account`,
'0'											                       `tender_num`,
'0'											                       `tender_times`,
'0'											                       `hits`,
create_time							                       `time_h`,
amount											                   `borrow_account_yes`,
amount-amount										               `borrow_account_wait`,
if(full_time="0000-00-00 00:00:00",'0','100')  `borrow_account_scale`,
'0'																					   `borrow_times`,
'0.00'																			   `dj_bzj`,
'0.00'																				 `dj_sq`,
'0'																					   `attrv`,
'0'																					   `autorepay`
from rz_borrow.rz_borrow
where create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 2 DAY),"%Y-%m-%d 23:59:59") and create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");
insert into 05b_0base_run
(`bid`, `account`, `tender_num`, `tender_times`, `hits`, `time_h`, `borrow_account_yes`,
`borrow_account_wait`, `borrow_account_scale`, `borrow_times`, `dj_bzj`, `dj_sq`, `attrv`, `autorepay`)
select `bid`, `account`, `tender_num`, `tender_times`, `hits`, `time_h`, `borrow_account_yes`,
`borrow_account_wait`, `borrow_account_scale`, `borrow_times`, `dj_bzj`, `dj_sq`, `attrv`, `autorepay`
from wd.05b_0base_run
where time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");

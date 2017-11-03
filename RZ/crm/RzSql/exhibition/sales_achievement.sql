#电销业绩
SELECT  COALESCE(a.uname, "总计") kefu,sum(a.account) tz_j,round(sum(a.nianhua),2) nianhua,sum(a.recover_account) recover_account
from
(
			SELECT k.uname,0 recover_account,case when t1.days!=0 then a1.account*t1.days/360 else a1.account*t1.borrow_period/12 end nianhua,
			a1.account
			from 05b_1tenderfinal a1
			INNER JOIN 05b_0base t1 on a1.bid = t1.bid
			INNER JOIN 01u_0info b on a1.uid=b.uid
			INNER JOIN 01u_2worker k on b.uid_kefu = k.uid
			where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
			and b.uid_kefu in (1285094,1285095,1285099,1285100)
			and a1.time_h >= "{start_time}"
			and a1.time_h < DATE_ADD("{end_time}",INTERVAL 1 day)
			UNION ALL
			SELECT k.uname,0 recover_account,case when t3.borrow_time_type!=0 then a3.real_amount*t3.time_limit/360 else a3.real_amount*t3.time_limit/12 end nianhua,
			a3.real_amount account
			from new_wd.rz_borrow_tender a3
			INNER JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
			INNER JOIN 01u_0info b on a3.user_id=b.uid
			INNER JOIN 01u_2worker k on b.uid_kefu = k.uid
			where a3.`status` = 1
			and b.uid_kefu in (1285094,1285095,1285099,1285100)
			and a3.create_time >= "{start_time}"
			and a3.create_time < DATE_ADD("{end_time}",INTERVAL 1 day)
			UNION ALL
			SELECT k.uname,a1.recover_account,0 nianhua,0 account
			from 05b_2list_recover a1
			INNER JOIN 01u_0info b on a1.uid=b.uid
			INNER JOIN 01u_2worker k on b.uid_kefu = k.uid
			where a1.bid <> 10000
			and a1.recover_status in (0,1)
			and b.uid_kefu in (1285094,1285095,1285099,1285100)
			and a1.time_h < DATE_ADD("{end_time}",INTERVAL 1 day)
			and a1.recover_times >= DATE_ADD("{end_time}",INTERVAL 1 day)
			UNION ALL
			SELECT k.uname,a3.repayment_amount,0 nianhua,0 account
			from new_wd.rz_borrow_collection a3
			INNER JOIN 01u_0info b on a3.user_id=b.uid
			INNER JOIN 01u_2worker k on b.uid_kefu = k.uid
			where a3.`status` in (0,1)
			and b.uid_kefu in (1285094,1285095,1285099,1285100)
			and a3.create_time < DATE_ADD("{end_time}",INTERVAL 1 day)
			and a3.repayment_time >= DATE_ADD("{end_time}",INTERVAL 1 day)
) a
GROUP BY a.uname
WITH ROLLUP
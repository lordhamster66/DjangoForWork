# 短标投资详情
SELECT  count(DISTINCT(a.uid)) short_tz_r,sum(a.account) short_tz_j
from
(
			SELECT a1.borrow_id bid,t1.name,t1.apr borrow_apr,
			case when t1.borrow_time_type!=0 then t1.time_limit else t1.time_limit*30 end qixian,
			a1.user_id uid,a1.real_amount account,a1.create_time time_h
			from rz_borrow.rz_borrow_tender a1
			INNER JOIN rz_borrow.rz_borrow t1 on a1.borrow_id = t1.id
			where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
			and a1.create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a1.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			SELECT a2.borrow_id bid,t2.name,t2.apr,
			case when t2.borrow_time_type!=0 then t2.time_limit else t2.time_limit*30 end qixian,
			a2.user_id uid,a2.real_amount account,a2.add_time time_h
			from new_wd.borrow_tender a2
			INNER JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
			where a2.status = 1
			and a2.add_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a2.add_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day)
			union all
			SELECT a3.borrow_id bid,a3.name,a3.apr,
			case when a3.borrow_time_type!=0 then a3.time_limit else a3.time_limit*30 end qixian,
			a3.user_id uid,a3.real_amount account,a3.create_time time_h
			from
			(
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_0 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_1 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_2 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_3 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_4 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_5 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_6 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_7 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_8 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_9 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_10 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_11 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_12 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_13 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_14 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_15 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_16 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_17 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_18 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_19 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_20 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_21 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_22 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_23 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_24 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_25 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_26 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_27 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_28 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_29 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_30 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))  union all
					(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_31 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and a.create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day) and a.create_time < DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 day))
			) a3
) a
INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
where b.customer_user_id not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.qixian < 30  # 30天以内短标
;
SELECT a.uid,a.uname,a.mobile,a.time_h,s.update_time,q.name,t.account,t.time_h,t.qixian,t.name
from 01u_0info a
LEFT JOIN 01u_0qudao q on a.uid = q.uid
LEFT JOIN
(
	SELECT a.uid,a.update_time
	from rz_cg_user_ext a
	where `status` = 1
	and is_authentication = 1
	and is_tied_card = 1
) s on a.uid = s.uid
LEFT JOIN
(
		SELECT  a.uid,a.time_h,a.account,a.qixian,a.name
		from
		(
			SELECT a1.bid,t1.name,t1.borrow_apr,a1.aprplus,
			case when t1.days!=0 then concat(t1.days,"天") else concat(t1.borrow_period,"月") end qixian,
			a1.uid,a1.account,a1.time_h,a1.hbid
			from 05b_1tenderfinal a1
			LEFT JOIN 05b_0base t1 on a1.bid = t1.bid
			where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
			union all
			SELECT a2.borrow_id bid,t2.name,t2.apr,'0' aprplus,
			case when t2.borrow_time_type!=0 then concat(t2.time_limit,"天") else concat(t2.time_limit,"月") end qixian,
			a2.user_id uid,a2.real_amount account,a2.add_time time_h,'0' hbid
			from new_wd.borrow_tender a2
			LEFT JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
			where a2.status = 1
			union all
			SELECT a3.borrow_id bid,t3.name,t3.apr,'0' aprplus,
			case when t3.borrow_time_type!=0 then concat(t3.time_limit,"天") else concat(t3.time_limit,"月") end qixian,
			a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
			from new_wd.rz_borrow_tender a3
			LEFT JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
			where a3.`status` = 1
		) a
		LEFT JOIN (
							SELECT h1.uid,ifnull(min(h1.time_h),0) min_time
							from
										(
											SELECT a1.uid,a1.account,a1.time_h
											from 05b_1tenderfinal a1
											LEFT JOIN 05b_0base t1 on a1.bid = t1.bid
											where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
											union all
											SELECT a2.user_id uid,a2.real_amount account,a2.add_time time_h
											from new_wd.borrow_tender a2
											where a2.status = 1
											union all
											select a3.user_id uid,a3.real_amount account,a3.create_time time_h
											from new_wd.rz_borrow_tender a3
											where a3.status = 1
										) h1
						 GROUP BY h1.uid
						 ) t on a.uid = t.uid
		where a.time_h = t.min_time
) t on a.uid = t.uid
where a.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and unix_timestamp(s.update_time) >= unix_timestamp("{start_time}")
and unix_timestamp(s.update_time) < unix_timestamp("{end_time}")+86400
and q.name in ({name})


























































































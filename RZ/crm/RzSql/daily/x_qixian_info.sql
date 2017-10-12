SELECT a.qdate,a.qixian term,sum(a.tz_r) tz_r,sum(a.tz_j) tz_j,sum(a.mb_ys) mb_ys
from
(
		SELECT DATE(a.time_h) qdate,a.qixian,count(DISTINCT(a.uid)) tz_r,sum(a.account) tz_j,0 mb_ys
		from
		(
				SELECT a3.borrow_id bid,t3.name,t3.apr,'0' aprplus,
				case when t3.borrow_time_type!=0 then t3.time_limit else t3.time_limit*30 end qixian,
				a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
				from new_wd.rz_borrow_tender a3
				LEFT JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
				where a3.`status` = 1
				and DATE(a3.create_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
		) a
		LEFT JOIN  01u_0info c on a.uid=c.uid
		where  c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
		and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
		GROUP BY DATE(a.time_h),a.qixian
		UNION ALL
		SELECT DATE(h.max_time) qdate,h.qixian,0 tz_r,0 tz_j,avg(h.time) mb_ys
			from
				(
								SELECT t.name,t.id,
								case when t.borrow_time_type!=0 then t.time_limit else t.time_limit*30 end qixian,
								(UNIX_TIMESTAMP(max(a.create_time))-UNIX_TIMESTAMP(min(t.put_start_time)))/3600 time, -- 计算满标用时
								max(a.create_time) max_time                                                      -- 满标时间
								from new_wd.rz_borrow_big t                                                     -- 投资报表
								LEFT JOIN  new_wd.rz_borrow_tender a on a.borrow_id=t.id                        -- 标的详情表
								where t.scales = 100                                                     -- 完成率100表示满标
								and t.status <> 2                                                        -- 剔除初审失败
								and t.status <> 4                                                        -- 剔除复审失败
								and t.status <> -1                                                       -- 剔除已撤回
								and t.status <> 5                                                        -- 剔除用户自行撤销
								and a.status = 1
								GROUP BY t.id
				) h
		where DATE(h.max_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
		GROUP BY DATE(h.max_time),h.qixian
) a
GROUP BY a.qdate,a.qixian









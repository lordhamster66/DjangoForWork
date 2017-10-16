SELECT a.qdate,a.qixian term,sum(a.tz_r) tz_r,sum(a.tz_j) tz_j,sum(a.mb_ys) mb_ys
from
(
		SELECT DATE(a.time_h) qdate,a.qixian,count(DISTINCT(a.uid)) tz_r,sum(a.account) tz_j,0 mb_ys
		from
		(
				SELECT a1.bid,t1.name,t1.borrow_apr,a1.aprplus,
				case when t1.days!=0 then t1.days else t1.borrow_period*30 end qixian,
				a1.uid,a1.account,a1.time_h,a1.hbid
				from 05b_1tenderfinal a1
				INNER JOIN 05b_0base t1 on a1.bid = t1.bid
				where a1.orguid = 0 and a1.bid <> 10000 and a1.status in (1,3)
				and DATE(a1.time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
				union all
				SELECT a2.borrow_id bid,t2.name,t2.apr,'0' aprplus,
				case when t2.borrow_time_type!=0 then t2.time_limit else t2.time_limit*30 end qixian,
				a2.user_id uid,a2.real_amount account,a2.add_time time_h,'0' hbid
				from new_wd.borrow_tender a2
				INNER JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
				where a2.status = 1
				and DATE(a2.add_time) = DATE_SUB(curdate(),INTERVAL 1 DAY)
				union all
				SELECT a3.borrow_id bid,t3.name,t3.apr,'0' aprplus,
				case when t3.borrow_time_type!=0 then t3.time_limit else t3.time_limit*30 end qixian,
				a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
				from new_wd.rz_borrow_tender a3
				INNER JOIN new_wd.rz_borrow_big t3 on a3.borrow_id = t3.id
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
								SELECT t.name,t.bid,
								case when t.days!=0 then t.days else t.borrow_period*30 end qixian,
								(UNIX_TIMESTAMP(max(a.time_h))-UNIX_TIMESTAMP(t.verify_time))/3600 time, -- 计算满标用时
								max(a.time_h) max_time                                                   -- 最后一笔投资时间近似为满标时间
								from 05b_0base t                                                         -- 投资报表
								LEFT JOIN  05b_1tenderfinal a on a.bid=t.bid                             -- 标的详情表
								LEFT JOIN 05b_0base_run m on a.bid=m.bid                                 -- 标的完成进度表
								where a.bid <> 10000                                                     -- 剔除体验标
								and a.orguid = 0                                                         -- 剔除债券转让
								and a.status in(1,3)
								and m.borrow_account_scale = 100                                         -- 完成率100表示满标
								and t.status <> 2                                                        -- 剔除初审失败
								and t.status <> 4                                                        -- 剔除复审失败
								and t.status <> 5                                                        -- 剔除用户自行撤销
								GROUP BY t.bid
								UNION ALL
								SELECT t.name,t.id,
								case when t.borrow_time_type!=0 then t.time_limit else t.time_limit*30 end qixian,
								(UNIX_TIMESTAMP(max(a.add_time))-UNIX_TIMESTAMP(min(t.put_start_time)))/3600 time, -- 计算满标用时
								max(a.add_time) max_time                                                     -- 最后一笔投资时间近似为满标时间
								from new_wd.borrow t                                                         -- 投资报表
								LEFT JOIN  new_wd.borrow_tender a on a.borrow_id=t.id                        -- 标的详情表
								where t.scales = 100                                                     -- 完成率100表示满标
								and t.status <> 2                                                        -- 剔除初审失败
								and t.status <> 4                                                        -- 剔除复审失败
								and t.status <> -1                                                       -- 剔除已撤回
								and t.status <> 5                                                        -- 剔除用户自行撤销
								and a.status = 1
								GROUP BY t.id
								UNION ALL
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
;








SELECT n.uname kefuname,f.ft_r,s.st_r,f.ft_r/s.st_r ft_lv,f.ft_j,t.t_j day_t_j,t1.t_j month_t_j
from
        # 所有专属客服
(
				SELECT uname
				from 01u_2worker
				where uid in (156955,319032,933452,1037495,1465540,1468495,1468496)
) n
LEFT JOIN
(
					SELECT c.uname,count(DISTINCT(a.uid)) ft_r,sum(a.account) ft_j
					# 投资详情
					from (
								SELECT uid,time_h,account from 05b_1tenderfinal
								where orguid=0 and bid <> 10000 and status in (1,3)
								and time_h >=  DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
								and time_h < CURDATE()
								UNION ALL
								SELECT user_id,add_time,real_amount from new_wd.borrow_tender
								where status = 1
								and add_time >=  DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
								and add_time < CURDATE()
								UNION ALL
								SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
								where status = 1
								and create_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
								and create_time < CURDATE()
							 ) a
					LEFT JOIN 01u_0info b on a.uid=b.uid
					LEFT JOIN 01u_0info c on b.uid_kefu = c.uid
					LEFT JOIN
					# 最小投资时间详情
					(
							SELECT h1.uid,min(h1.time_h) min_time
							from
								(
									SELECT a1.uid,a1.account,a1.time_h
									from 05b_1tenderfinal a1
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
					INNER JOIN
					# 本月加前两月首投用户
					(
								SELECT a.uid
								from
								(
									SELECT uid,time_h,account from 05b_1tenderfinal
									where orguid=0 and bid <> 10000 and status in (1,3)
									and time_h >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
									and time_h < CURDATE()
									UNION ALL
									SELECT user_id,add_time,real_amount from new_wd.borrow_tender
									where status = 1
									and add_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
									and add_time < CURDATE()
									UNION ALL
									SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
									where status = 1
									and create_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
									and create_time < CURDATE()
								) a
								LEFT JOIN (
														SELECT h1.uid,min(h1.time_h) min_time
														from
																	(
																		SELECT a1.uid,a1.account,a1.time_h
																		from 05b_1tenderfinal a1
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
								LEFT JOIN 01u_0info b on a.uid = b.uid                   #b.tjr = ""则为非推荐人新增,b.tjr != "" 则为推荐人新增
								LEFT JOIN 01u_0info c on b.uid_kefu = c.uid
								LEFT JOIN 01u_0base e on b.uid_kefu = e.uid
								LEFT JOIN 01u_0qudao q on a.uid = q.uid
								where b.uid_kefu in (156955,319032,933452,1037495,1465540,1468495,1468496)
								and b.tjr = ""
								and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
								and a.time_h = t.min_time
								and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
								GROUP BY a.uid
					) s on a.uid = s.uid  # 限定人数为本月加前两月首投用户
					where b.uid_kefu in (156955,319032,933452,1037495,1465540,1468495,1468496)
					and a.time_h <> t.min_time  # 限定复投
					GROUP BY c.uname
) f on n.uname = f.uname
LEFT JOIN
# 本月加前两月首投用户详情
(
		SELECT c.uname,count(DISTINCT(a.uid)) st_r
		from
		(
				SELECT uid,time_h,account from 05b_1tenderfinal
				where orguid=0 and bid <> 10000 and status in (1,3)
				and time_h >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
				and time_h < CURDATE()
				UNION ALL
				SELECT user_id,add_time,real_amount from new_wd.borrow_tender
				where status = 1
				and add_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
				and add_time < CURDATE()
				UNION ALL
				SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
				where status = 1
				and create_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
				and create_time < CURDATE()
		) a
		LEFT JOIN
		(
				SELECT h1.uid,min(h1.time_h) min_time
					from
								(
									SELECT a1.uid,a1.account,a1.time_h
									from 05b_1tenderfinal a1
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
		LEFT JOIN 01u_0info b on a.uid = b.uid
		LEFT JOIN 01u_0info c on b.uid_kefu = c.uid
		LEFT JOIN 01u_0base e on b.uid_kefu = e.uid
		LEFT JOIN 01u_0qudao q on a.uid = q.uid
		where b.uid_kefu in (156955,319032,933452,1037495,1465540,1468495,1468496)
		and b.tjr = ""
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		and a.time_h = t.min_time
		and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
		GROUP BY c.uname
) s on n.uname = s.uname
LEFT JOIN
# 当日投资金额
(
		SELECT c.uname,sum(a.account) t_j
		from (
					SELECT uid,time_h,account from 05b_1tenderfinal
					where orguid=0 and bid <> 10000 and status in (1,3)
					UNION ALL
					SELECT user_id,add_time,real_amount from new_wd.borrow_tender
					where status = 1
					UNION ALL
					SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
					where status = 1
				 ) a
		LEFT JOIN 01u_0info b on a.uid=b.uid
		LEFT JOIN 01u_0info c on b.uid_kefu = c.uid
		LEFT JOIN 01u_0qudao q on a.uid = q.uid
		where b.uid_kefu in (156955,319032,933452,1037495,1465540,1468495,1468496)
		and a.time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		and b.tjr = ""
		GROUP BY c.uname
) t on n.uname = t.uname
LEFT JOIN
# 当月投资金额
(
		SELECT c.uname,sum(a.account) t_j
		from (
					SELECT uid,time_h,account from 05b_1tenderfinal
					where orguid=0 and bid <> 10000 and status in (1,3)
					UNION ALL
					SELECT user_id,add_time,real_amount from new_wd.borrow_tender
					where status = 1
					UNION ALL
					SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
					where status = 1
				 ) a
		LEFT JOIN 01u_0info b on a.uid=b.uid
		LEFT JOIN 01u_0info c on b.uid_kefu = c.uid
		LEFT JOIN 01u_0qudao q on a.uid = q.uid
		where b.uid_kefu in (156955,319032,933452,1037495,1465540,1468495,1468496)
		and a.time_h >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		and b.tjr = ""
		GROUP BY c.uname
) t1 on n.uname = t1.uname
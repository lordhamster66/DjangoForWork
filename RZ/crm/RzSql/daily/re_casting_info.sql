SELECT n.uname kefuname,f.ft_r,s.st_r,f.ft_r/s.st_r ft_lv,f.ft_j,t.t_j day_t_j,t1.t_j month_t_j
from
        # 所有专属客服
(
				SELECT name uname
				from rz_s.rz_s_operator
				where id in (933452,1037495,26,27,28,36)
) n
LEFT JOIN
(
					SELECT k.name uname,count(DISTINCT(a.uid)) ft_r,sum(a.account) ft_j
					# 投资详情
					from (
								SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
								where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
								and create_time >=  DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
								and create_time < CURDATE()
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
					INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
					INNER JOIN rz_s.rz_s_operator k on b.customer_user_id = k.id
					LEFT JOIN
					# 最小投资时间详情
					(
							SELECT h1.uid,min(h1.time_h) min_time
							from
								(
									SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
									from rz_borrow.rz_borrow_tender a1
									where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
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
									SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
									where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
									and create_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
									and create_time < CURDATE()
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
																		SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
																		from rz_borrow.rz_borrow_tender a1
																		where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
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
								INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
								INNER JOIN rz_s.rz_s_operator k on b.customer_user_id = k.id
								LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
								LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
								where b.customer_user_id in (933452,1037495,26,27,28,36)
								# and i.user_id is null # 剔除邀请
								and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
								and a.time_h = t.min_time
								# and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)  # TODO 客服设置时间数据库丢失
								GROUP BY a.uid
					) s on a.uid = s.uid  # 限定人数为本月加前两月首投用户
					where b.customer_user_id in (933452,1037495,26,27,28,36)
					and a.time_h <> t.min_time  # 限定复投
					GROUP BY k.name
) f on n.uname = f.uname
LEFT JOIN
# 本月加前两月首投用户详情
(
		SELECT k.name uname,count(DISTINCT(a.uid)) st_r
		from
		(
				SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
				where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
				and create_time >=  DATE_SUB(DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 2 MONTH), INTERVAL DAY(DATE_SUB(CURDATE(),INTERVAL 1 day)) -1 DAY)
				and create_time < CURDATE()
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
									SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
									from rz_borrow.rz_borrow_tender a1
									where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
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
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		INNER JOIN rz_s.rz_s_operator k on b.customer_user_id = k.id
		LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		where b.customer_user_id in (933452,1037495,26,27,28,36)
		# and i.user_id is null # 剔除邀请
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		and a.time_h = t.min_time
		# and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)  # TODO 客服设置时间数据库丢失
		GROUP BY k.name
) s on n.uname = s.uname
LEFT JOIN
# 当日投资金额
(
		SELECT k.name uname,sum(a.account) t_j
		from (
					SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
					from rz_borrow.rz_borrow_tender a1
					where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
					UNION ALL
					SELECT user_id,add_time,real_amount from new_wd.borrow_tender
					where status = 1
					UNION ALL
					SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
					where status = 1
				 ) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		INNER JOIN rz_s.rz_s_operator k on b.customer_user_id = k.id
		LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		where b.customer_user_id in (933452,1037495,26,27,28,36)
		and a.time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		# and i.user_id is null # 剔除邀请
		GROUP BY k.name
) t on n.uname = t.uname
LEFT JOIN
# 当月投资金额
(
		SELECT k.name uname,sum(a.account) t_j
		from (
					SELECT a1.user_id uid,a1.real_amount account,a1.create_time time_h
					from rz_borrow.rz_borrow_tender a1
					where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6,11) and a1.deleted = 0  # 记录没被删除
					UNION ALL
					SELECT user_id,add_time,real_amount from new_wd.borrow_tender
					where status = 1
					UNION ALL
					SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
					where status = 1
				 ) a
		INNER JOIN rz_user.rz_user_base_info b on a.uid = b.user_id
		INNER JOIN rz_s.rz_s_operator k on b.customer_user_id = k.id
		LEFT JOIN (SELECT `code`,name from rz_article.rz_channel GROUP BY `code`) q on b.utm_source = q.`code`
		LEFT JOIN rz_user.rz_user_invite i on a.uid = i.user_id
		where b.customer_user_id in (933452,1037495,26,27,28,36)
		and a.time_h >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		# and i.user_id is null # 剔除邀请
		GROUP BY k.name
) t1 on n.uname = t1.uname
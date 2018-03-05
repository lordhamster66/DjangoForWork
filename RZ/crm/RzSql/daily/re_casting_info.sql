SELECT n.uname kefuname,f.ft_r,f.st_r,f.ft_r/f.st_r ft_lv,f.ft_j,
f1.ft_r one_month_ft_r,f1.st_r one_month_st_r,f1.ft_r/f1.st_r one_month_ft_lv,f1.ft_j one_month_ft_j,
f2.ft_r two_month_ft_r,f2.st_r two_month_st_r,f2.ft_r/f2.st_r two_month_ft_lv,f2.ft_j two_month_ft_j,
t.t_j day_t_j,t1.t_j month_t_j
from
# 所有专属客服
(
				SELECT name uname
				from rz_s.rz_s_operator
				where id in (933452,1037495,26,27,28,36)
) n
LEFT JOIN
(
					SELECT k.name uname,
					count(DISTINCT case when a.time_h <> t.min_time and a.uid = s.uid then a.uid else null end) ft_r,
					sum(case when a.time_h <> t.min_time and a.uid = s.uid then a.account else 0 end) ft_j,
					count(DISTINCT s.uid) st_r
					from
					# 本月加前两月首投用户
					(
								SELECT a.uid
								from
								(
									SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
									where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
									and create_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
									and create_time < CURDATE()
									UNION ALL
									SELECT user_id,add_time,real_amount from new_wd.borrow_tender
									where status = 1
									and add_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
									and add_time < CURDATE()
									UNION ALL
									SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
									where status = 1
									and create_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
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
								where b.customer_user_id in (933452,1037495,26,27,28,36)
								and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
								and a.time_h = t.min_time
								# and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)  # TODO 客服设置时间数据库丢失
								GROUP BY a.uid
					) s
					INNER JOIN rz_user.rz_user_base_info b on s.uid = b.user_id
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
					) t on s.uid = t.uid
					LEFT JOIN
					# 投资详情
					(
								SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
								where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
								and create_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and create_time < CURDATE()
								UNION ALL
								SELECT user_id,add_time,real_amount from new_wd.borrow_tender
								where status = 1
								and add_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and add_time < CURDATE()
								UNION ALL
								SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
								where status = 1
								and create_time >= DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and create_time < CURDATE()
				  ) a on s.uid = a.uid
					where b.customer_user_id in (933452,1037495,26,27,28,36)
					GROUP BY k.name
) f on n.uname = f.uname
LEFT JOIN
(
					SELECT k.name uname,
					count(DISTINCT case when a.time_h <> t.min_time and a.uid = s.uid then a.uid else null end) ft_r,
					sum(case when a.time_h <> t.min_time and a.uid = s.uid then a.account else 0 end) ft_j,
					count(DISTINCT s.uid) st_r
					from
					# 投资详情
					(
								SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
								where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
								and create_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and create_time < CURDATE()
								UNION ALL
								SELECT user_id,add_time,real_amount from new_wd.borrow_tender
								where status = 1
								and add_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and add_time < CURDATE()
								UNION ALL
								SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
								where status = 1
								and create_time >= DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
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
					LEFT JOIN
					# 本月首投用户
					(
								SELECT a.uid
								from
								(
									SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
									where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
									and create_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
									and create_time < CURDATE()
									UNION ALL
									SELECT user_id,add_time,real_amount from new_wd.borrow_tender
									where status = 1
									and add_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
									and add_time < CURDATE()
									UNION ALL
									SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
									where status = 1
									and create_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
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
								where b.customer_user_id in (933452,1037495,26,27,28,36)
								and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
								and a.time_h = t.min_time
								# and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)  # TODO 客服设置时间数据库丢失
								GROUP BY a.uid
					) s on a.uid = s.uid
					where b.customer_user_id in (933452,1037495,26,27,28,36)
					GROUP BY k.name
) f1 on n.uname = f1.uname
LEFT JOIN
(
					SELECT k.name uname,
					count(DISTINCT case when a.time_h <> t.min_time and a.uid = s.uid then a.uid else null end) ft_r,
					sum(case when a.time_h <> t.min_time and a.uid = s.uid then a.account else 0 end) ft_j,
					count(DISTINCT s.uid) st_r
					from
					# 前两月首投用户详情
					(
								SELECT a.uid
								from
								(
									SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
									where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
									and create_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
									and create_time < DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
									UNION ALL
									SELECT user_id,add_time,real_amount from new_wd.borrow_tender
									where status = 1
									and add_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
									and add_time < DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
									UNION ALL
									SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
									where status = 1
									and create_time >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day),INTERVAL 2 MONTH)
									and create_time < DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
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
								where b.customer_user_id in (933452,1037495,26,27,28,36)
								and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
								and a.time_h = t.min_time
								# and b.kefu_settime < DATE_SUB(DATE_ADD(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL 1 MONTH),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)  # TODO 客服设置时间数据库丢失
								GROUP BY a.uid
					) s
					INNER JOIN rz_user.rz_user_base_info b on s.uid = b.user_id
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
					) t on s.uid = t.uid
					LEFT JOIN
					# 投资详情
					(
								SELECT user_id uid,create_time time_h,real_amount account from rz_borrow.rz_borrow_tender
								where borrow_id <> 10000 and `status` in (0,1,2,3,4,5,6,11) and deleted = 0  # 记录没被删除
								and create_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and create_time < CURDATE()
								UNION ALL
								SELECT user_id,add_time,real_amount from new_wd.borrow_tender
								where status = 1
								and add_time >=  DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and add_time < CURDATE()
								UNION ALL
								SELECT user_id,create_time,real_amount from new_wd.rz_borrow_tender
								where status = 1
								and create_time >= DATE_SUB(CURDATE(),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day)) day)
								and create_time < CURDATE()
					) a on s.uid = a.uid
					where b.customer_user_id in (933452,1037495,26,27,28,36)
					GROUP BY k.name
) f2 on n.uname = f2.uname
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
		where b.customer_user_id in (933452,1037495,26,27,28,36)
		and a.time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
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
		where b.customer_user_id in (933452,1037495,26,27,28,36)
		and a.time_h >= DATE_SUB(DATE_SUB(CURDATE(),INTERVAL 1 day),INTERVAL day(DATE_SUB(CURDATE(),INTERVAL 1 day))-1 day)
		and a.time_h < CURDATE()
		and (q.name not in ("app-tangzhuan","app-huoniao","app-youcai","wap-youcai","wap-youcai1","app-yc01","app-hainiaowo","app-zhs","app-bank","wap-z800","app-z800-3") or q.name is null)
		GROUP BY k.name
) t1 on n.uname = t1.uname
;
SELECT ifnull(t3.`邀请人(旧版)`,0)+ifnull(t4.`邀请人(新版)`,0) invite_r,
ifnull(t3.`被邀请人(旧版)`,0)+ifnull(t4.`被邀请人(新版)`,0) invited_r,
ifnull(t1.`首投人数(旧版)`,0) + IFNULL(t2.`首投人数(新版)`,0) invited_st_r,
ifnull(t1.`首投金额(旧版)`,0) + IFNULL(t2.`首投金额(新版)`,0) invited_st_j,
ifnull(t5.`发放现金(旧版)`,0) + IFNULL(t12.`首投花费(新版)`,0) cash_f,
ifnull(t10.`当月总投资金额(旧版)`,0) + IFNULL(t11.`当月总投资金额(新版)`,0) 总投资金额,
ifnull(t5.`发放现金(旧版)`,0) + ifnull(t9.`加息利息(旧版)`,0) + IFNULL(t6.`佣金(新版)`,0) + IFNULL(t7.`50元现金发放金额(新版)`,0) + IFNULL(t8.`10元红包使用金额(新版)`,0) + IFNULL(t8.`90元红包使用金额(新版)`,0) 总花费
from
(
		SELECT 1 nid
		from 01u_0qudao_url
		GROUP BY 1
) a
INNER JOIN
(
		SELECT 1 nid,count(DISTINCT(a.uid)) '首投人数(旧版)',sum(a.account) '首投金额(旧版)'
		from
		(
				SELECT uid,time_h,account
				from 05b_1tenderfinal
				where orguid=0 and status in (1,3) and bid <> 10000
				and time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
				and time_h < CURDATE()
				UNION ALL
				SELECT user_id,add_time,real_amount
				from new_wd.borrow_tender
				where status = 1
				and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
				and add_time < CURDATE()
				UNION ALL
				SELECT user_id,create_time,real_amount
				from new_wd.rz_borrow_tender
				where `status` = 1
				and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
				and create_time < CURDATE()
		) a
		INNER JOIN
		(
				SELECT h1.uid,min(h1.time_h) min_time
				from
				(
					SELECT a1.uid,a1.account,a1.time_h
					from 05b_1tenderfinal a1
					where a1.orguid = 0 and a1.status in (1,3) and a1.bid <> 10000
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
		) t on a.uid = t.uid and a.time_h = t.min_time
		INNER JOIN
		(
				SELECT a.uid
				from  01u_9tjr a
				where a.time_h < CURDATE()
		) z on a.uid = z.uid
) t1 on a.nid = t1.nid
INNER JOIN
(
		SELECT 1 nid,count(DISTINCT(a.uid)) '首投人数(新版)',sum(a.account) '首投金额(新版)'
		from
		(
						SELECT uid,time_h,account
						from 05b_1tenderfinal
						where orguid=0 and status in (1,3) and bid <> 10000
						and time_h >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and time_h < CURDATE()
						UNION ALL
						SELECT user_id,add_time,real_amount
						from new_wd.borrow_tender
						where status = 1
						and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and add_time < CURDATE()
						UNION ALL
						SELECT user_id,create_time,real_amount
						from new_wd.rz_borrow_tender
						where `status` = 1
						and create_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and create_time < CURDATE()
		) a
		INNER JOIN
		(
						SELECT h1.uid,min(h1.time_h) min_time
						from
						(
						SELECT a1.uid,a1.account,a1.time_h
						from 05b_1tenderfinal a1
						where a1.orguid = 0 and a1.status in (1,3) and a1.bid <> 10000
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
		) t on a.uid = t.uid and a.time_h = t.min_time
		INNER JOIN
		(
						SELECT DISTINCT a.buid uid
						from  rz_invite_user a
						where a.reg_time < CURDATE()
		) z on a.uid = z.uid
) t2 on a.nid = t2.nid
INNER JOIN
(
		SELECT 1 nid,count(DISTINCT(a.uid_tjr)) '邀请人(旧版)',count(DISTINCT(a.uid)) '被邀请人(旧版)'
		from  01u_9tjr a
		where a.time_h >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.time_h < CURDATE()
) t3 on a.nid = t3.nid
INNER JOIN
(
		SELECT 1 nid,count(DISTINCT(a.uid)) '邀请人(新版)',count(DISTINCT(a.buid)) '被邀请人(新版)'
		from  rz_invite_user a
		where a.reg_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.reg_time < CURDATE()
) t4 on a.nid = t4.nid
INNER JOIN
(
		SELECT 1 nid,sum(a.money ) '发放现金(旧版)'
		from rz_inviter_record  a
		where a.inviter_id in
		(
			SELECT a.uid_tjr
			from  01u_9tjr a
			where a.time_h < CURDATE()
			UNION
			SELECT a.uid
			from  01u_9tjr a
			where a.time_h < CURDATE()
		)
		and a.name not in( "人脉王金奖",'人脉王银奖','人脉王铜奖')
		and a.is_status=0
		and a.create_time >= unix_timestamp(DATE_SUB(CURDATE(),INTERVAL 1 day) )
		and a.create_time < unix_timestamp(CURDATE())
) t5 on a.nid = t5.nid
INNER JOIN
(
		SELECT 1 nid,sum(a.money) '佣金(新版)'
		from rz_invite_flow a
		where a.brokerage <> 0
		and a.`status` = 1
		and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.ctime < CURDATE()
		and a.buid in
		(
		SELECT a.buid uid
		from  rz_invite_user a
		where a.reg_time < CURDATE()
		)
) t6 on a.nid = t6.nid
INNER JOIN
(
		SELECT 1 nid,sum(case when a.money = 50 then a.money else 0 end) '50元现金发放金额(新版)'
		from rz_invite_flow a
		where a.brokerage = 0
		and a.`status` = 1
		and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
		and a.ctime < CURDATE()
		and a.buid in
		(
		SELECT a.buid uid
		from  rz_invite_user a
		where a.reg_time < CURDATE()
		)
) t7 on a.nid = t7.nid
INNER JOIN
(
		SELECT 1 nid,sum(case when a.money = 10 then a.money else 0 end) '10元红包使用金额(新版)'
		,sum(case when a.money = 90 then a.money else 0 end) '90元红包使用金额(新版)'
		from
		(
				SELECT a.uid,a.hbid,a.money
				from 21h_0hongbao a
				where a.actname in ('邀请好友投资送10元红包','邀请好友投资送90元红包') and a.ispay = 1
				and a.time_use >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
				and a.time_use < CURDATE()
		) a
		where a.uid in
		(
		SELECT a.uid
		from  rz_invite_user a
		where a.reg_time < CURDATE()
		)
) t8 on a.nid = t8.nid
INNER JOIN
(
		SELECT 1 nid,sum(a.recover_account_interest_plus) '加息利息(旧版)'
		from (
			SELECT a.uid,a.hbid,b.account,a.money,c.borrow_apr,a.ispay,
			case when c.days!=0 then c.days else c.borrow_period*30 end qixian,b.recover_account_interest_plus
			from 21h_0hongbao a
			INNER JOIN 05b_1tenderfinal b on a.hbid = b.jxid
			INNER JOIN 05b_0base c on b.bid = c.bid
			where a.actname = '邀请人福利2%加息' and a.ispay = 1
			and a.time_use >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
			and a.time_use < CURDATE()
			GROUP BY 1,2,3,4,5,6,7,8
		) a
) t9 on a.nid = t9.nid
INNER JOIN
(
		SELECT 1 nid,sum(a.account) '当月总投资金额(旧版)'
		from
		(
						SELECT uid,time_h,account
						from 05b_1tenderfinal
						where orguid=0 and status in (1,3) and bid <> 10000
						and time_h >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and time_h < CURDATE()
						UNION ALL
						SELECT user_id,add_time,real_amount
						from new_wd.borrow_tender
						where status = 1
						and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and add_time < CURDATE()
						UNION ALL
						SELECT user_id,create_time,real_amount
						from new_wd.rz_borrow_tender
						where `status` = 1
						and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and create_time < CURDATE()
		 ) a
		INNER JOIN
		(
				SELECT a.uid
				from  01u_9tjr a
				where a.time_h < CURDATE()
		) z on a.uid = z.uid
		LEFT JOIN
		(
							SELECT h1.uid,min(h1.time_h) min_time
							from
							(
								SELECT a1.uid,a1.account,a1.time_h
								from 05b_1tenderfinal a1
								where a1.orguid = 0 and a1.status in (1,3) and a1.bid <> 10000
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
		where t.min_time >= date_add(curdate(), interval - day(curdate()) + 1 day)
) t10 on a.nid = t10.nid
INNER JOIN
(
		SELECT 1 nid,sum(a.account) '当月总投资金额(新版)'
		from
		(
						SELECT uid,time_h,account
						from 05b_1tenderfinal
						where orguid=0 and status in (1,3) and bid <> 10000
						and time_h >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and time_h < CURDATE()
						UNION ALL
						SELECT user_id,add_time,real_amount
						from new_wd.borrow_tender
						where status = 1
						and add_time >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and add_time < CURDATE()
						UNION ALL
						SELECT user_id,create_time,real_amount
						from new_wd.rz_borrow_tender
						where `status` = 1
						and create_time >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and create_time < CURDATE()
		 ) a
		INNER JOIN
		(
		SELECT DISTINCT a.buid uid
		from  rz_invite_user a
		where a.reg_time < CURDATE()
		) z on a.uid = z.uid
		LEFT JOIN
		(
						SELECT h1.uid,min(h1.time_h) min_time
						from
						(
						SELECT a1.uid,a1.account,a1.time_h
						from 05b_1tenderfinal a1
						where a1.orguid = 0 and a1.status in (1,3) and a1.bid <> 10000
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
		where t.min_time >= date_add(curdate(), interval - day(curdate()) + 1 day)
) t11 on a.nid = t11.nid
INNER JOIN
(
		SELECT 1 nid,(sum(a.`10元红包`)+sum(a.`50元现金`)+sum(a.`90元红包`)+sum(a.`佣金`)) '首投花费(新版)'
		FROM
		(
				SELECT sum(case when a.money = 10 then a.money else null end)'10元红包'
				,sum(case when a.money = 90 then a.money else null end)'90元红包',0 '50元现金',0 '佣金'
				FROM
				(
						SELECT a.*
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage = 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						and a.buid in
						(
						SELECT a.buid uid
						from  rz_invite_user a
						where a.reg_time < CURDATE()
						)
				) a
				INNER JOIN
				(
						SELECT a.buid,min(a.ctime)ctime
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage = 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						GROUP BY 1
				) b on a.buid = b.buid and a.ctime = b.ctime
				INNER JOIN
				(
						SELECT a.uid,a.hbid,a.money,a.time_use
						from 21h_0hongbao a
						where a.actname in ('邀请好友投资送10元红包','邀请好友投资送90元红包') and a.ispay = 1
						and a.time_use >=  DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.time_use < CURDATE()
				) c on a.htid = c.hbid
				union all
				SELECT 0,0,sum(case when a.money = 50 then a.money else null end)'50元现金',0
				FROM
				(
						SELECT a.*
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage = 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						and a.buid in
						(
						SELECT a.buid uid
						from  rz_invite_user a
						where a.reg_time < CURDATE()
						)
				) a
				INNER JOIN
				(
						SELECT a.buid,min(a.ctime)ctime
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage = 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						GROUP BY 1
				) b on a.buid = b.buid and a.ctime = b.ctime
		union all
				SELECT 0,0,0,sum(a.money)佣金
				FROM
				(
						SELECT a.*
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage <> 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						and a.buid in
						(
						SELECT a.buid uid
						from  rz_invite_user a
						where a.reg_time < CURDATE()
						)
				) a
				INNER JOIN
				(
						SELECT a.buid,min(a.htid)htid
						from rz_invite_flow a
						where a.`status` = 1 and a.brokerage <> 0
						and a.ctime >= DATE_SUB(CURDATE(),INTERVAL 1 day)
						and a.ctime < CURDATE()
						GROUP BY 1
				) b on a.htid = b.htid and a.buid = b.buid
		) a
) t12 on a.nid = t12.nid
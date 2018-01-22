# 散标期限详情
SELECT a.term,count(DISTINCT a.uid) tz_r,sum(a.account) tz_j
from
(
		SELECT a.uid,a.account,case when a.qixian < 10 then "A:1-10天"
		when a.qixian >= 10 and a.qixian < 30 then "B:10-30天"
		when a.qixian >= 30 and a.qixian < 60 then "C:1月标"
		when a.qixian >= 60 and a.qixian < 90 then "D:2月标"
		when a.qixian >= 90 and a.qixian < 180 then "E:3月标"
		else "F:6月标及以上"
		end term
		from
		(
				SELECT a1.borrow_id bid,t1.name,t1.apr borrow_apr,c1.up_apr aprplus,
				case when t1.borrow_time_type!=0 then t1.time_limit else t1.time_limit*30 end qixian,
				a1.user_id uid,a1.money account,a1.create_time time_h,a1.redpacket_id hbid
				from rz_borrow.rz_borrow_tender a1
				LEFT JOIN rz_activity.rz_additional_up_rate_tender c1 on a1.coupon_id = c1.up_rate_id
				INNER JOIN rz_borrow.rz_borrow t1 on a1.borrow_id = t1.id
				where a1.borrow_id <> 10000 and a1.`status` in (0,1,2,3,4,5,6) and a1.deleted = 0  # 记录没被删除
				and a1.create_time >= "{qdate}"
				and a1.create_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				union all
				SELECT a2.borrow_id bid,t2.name,t2.apr,'0' aprplus,
				case when t2.borrow_time_type!=0 then t2.time_limit else t2.time_limit*30 end qixian,
				a2.user_id uid,a2.real_amount account,a2.add_time time_h,'0' hbid
				from new_wd.borrow_tender a2
				INNER JOIN new_wd.borrow t2 on a2.borrow_id = t2.id
				where a2.status = 1
				and a2.add_time >= "{qdate}"
				and a2.add_time < DATE_ADD("{qdate}",INTERVAL 1 day)
				union all
				SELECT a3.borrow_id bid,a3.name,a3.apr,'0' aprplus,
				case when a3.borrow_time_type!=0 then a3.time_limit else a3.time_limit*30 end qixian,
				a3.user_id uid,a3.real_amount account,a3.create_time time_h,'0' hbid
				from
				(
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_0 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_1 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_2 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_3 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_4 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_5 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_6 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_7 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_8 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_9 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_10 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_11 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_12 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_13 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_14 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_15 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_16 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_17 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_18 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_19 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_20 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_21 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_22 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_23 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_24 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_25 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_26 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_27 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_28 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_29 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_30 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))  union all
						(SELECT a.*,b.name,b.apr,b.borrow_time_type,b.time_limit FROM new_wd.rz_borrow_tender_31 a INNER JOIN new_wd.rz_borrow_big b on a.big_borrow_id = b.id where a.`status` = 1 and b.product_id != 10020 and a.create_time >=  "{qdate}" and a.create_time < DATE_ADD("{qdate}",INTERVAL 1 day))
				) a3
		) a
) a
GROUP BY a.term
;
SELECT t4.recover_date qdate,t4.geduan geduan,sum(t4.yh) recover,sum(ifnull(t4.money,0)) recover_withdraw
from
(
	SELECT t3.uid,t3.money,t3.geduan,sum(t3.recover_account) yh,t3.recover_date
	from
	(
								 SELECT t2.uid,t2.recover_account,
								 case when (t2.qudao is null or t2.qudao="") and t2.register_url like "%app%" then "APP"
								 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and t2.register_url not like "%wx%" and t2.way=3 then "APP"
								 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and t2.register_url not like "%wx%" and t2.way=1 then "PC"
								 when (t2.qudao is null or t2.qudao="") and t2.register_url not like "%app%" and (t2.register_url  like "%wx%" or t2.way=2) then "WAP"
								 when (t2.qudao is null or t2.qudao="") and (t2.way is null or t2.way="") then "其他"
								 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=3 then "APP"
								 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=2 then "WAP"
								 when (t2.qudao is null or t2.qudao="") and (t2.register_url is null or t2.register_url="") and  t2.way=1 then "PC"
								 else t2.qudao end geduan,t2.money,t2.recover_date
					from
					(
									SELECT t1.uid,t1.register_url,t1.所属部门,
												 case when (t1.qudao is null or t1.qudao="")
												 and(t1.register_url like "%www.51rz.com/ind/registerTg.html%"
												 or t1.register_url like "%www.51rz.com/ind/h5/registerTg.html%"
												 or t1.register_url like "%www.51rz.com/ind/wx/tg/qd_welfare.html%"
												 or t1.register_url like "%www.51rz.com/ind/active/zzw.html%"
												 or t1.register_url like "%www.51rz.com/ind/wx/actie/reg_zzw.html%"
												 or t1.register_url like "%www.51rz.com/ind/wx/actie/programmer/ans_step01.html%"
												 or t1.register_url like "%www.51rz.com/ind/wx/actie/channelReg/spread_register.html%"
												 or t1.register_url like "%www.51rz.com/ind/PC/bwb_reg.html%") then "PC"
												 when t1.mobile in (18006817722,15957187705,15088718671,15618685415,17706527053,13750801989,13735801391,15158065171,15925636863) then "PC"
												 else t1.qudao end qudao,t1.recover_account,t1.way,t1.money,t1.recover_date
									from
									(
														SELECT a.uid,z.register_url,bu.所属部门,
																											case when bu.所属部门 = "PC" then "PC"
                          when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  q.name="pc-gw" then ""
													when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  u.qd_type = 'app' then 'APP'
                          when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  u.qd_type = 'PC端' then 'PC'
                          when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  u.qd_type = '微信' then 'WAP'
                          when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  u.qd_type = 'feed' then 'APP'
                          when (bu.所属部门 != "PC" or bu.所属部门 is null or bu.所属部门="") and  q.name = 'pc_lyh' then 'PC'
														when a.uid in (22245,23057,24588,25155,25184,25855,26524,28312,28612,28713,28808,29039,29447,29507,29534,29541,29641,30066,30080,30105,30184,30193,30201,30222,31074,31376,31506,31668,31683,31691,31981,32312,32665,32780,32809,33323,33467,33695,33827,34968,35319,35578,36692,37510,37951,38379,38817,38840,39301,39769,40639,40691,41080,41245,42104,42792,42852,43084,44188,44839,45972,46033,46362,46401,46494,46718,47024,47322,47835,47930,49406,50418,50430,50497,50538,50656,50696,50704,50724,50728,50757,50769,50787,50817,50848,50919,50930,50982,51130,51142,51240,51299,51312,51439,51455,52793,52816,52905,52941,53715,54094,54995,56080,56088,56122,56183,56696,56776,56992,57014,57451,57764,58584,59254,59445,60166,60438,61287,61629,62078,67294,67861,67880,68047,68146,68295,68333,68340,68425,68444,68448,68468,68471,68475,68482,68741,69181,69187,69329,69355,69430,69563,70074,70127,70166,70223,70356,71288,71860,71893,71900,71908,71918)
														then "PC"
														else q.name end qudao,
														c.way,c.mobile,a.recover_account,tx.money,date(a.recover_times) recover_date
														from (
																SELECT a1.uid,a1.recover_account,a1.recover_times
																from 05b_2list_recover a1
																where a1.bid <> 10000 and a1.recover_status in (0,1)
																UNION ALL
																SELECT r.user_id uid,r.real_total recover_account,DATE_ADD(t1.review_time,INTERVAL t1.time_limit DAY )as recover_times
																from new_wd.borrow_collection r
																LEFT JOIN new_wd.borrow t1 on r.borrow_id = t1.id
																where r.`status` in (0,1)
																and r.real_total > 0
																UNION ALL
																SELECT a3.user_id uid,a3.repayment_amount recover_account,a3.repayment_time recover_times
																from new_wd.rz_borrow_collection a3
																where a3.`status` in (0,1)
												       )  a
														LEFT JOIN 01u_0base b on a.uid=b.uid
														LEFT JOIN 01u_0info c on a.uid=c.uid
														LEFT JOIN 01u_0info d on c.uid_kefu=d.uid
														LEFT JOIN 01u_0qudao q on a.uid=q.uid
														LEFT JOIN 01u_0other z on a.uid=z.uid
														LEFT JOIN 01u_0qudao_url u on q.sign=u.qd_sign
														LEFT JOIN (
																			 SELECT uid,sum(abs(money)) money
																			 from 04a_3applyqueue
																			 where aptype=6 and uid_ty=1
																			 and DATE(time_h) = DATE_SUB(curdate(),INTERVAL 1 DAY)
																			 GROUP BY uid
																			 ) tx on a.uid=tx.uid
														LEFT JOIN (SELECT uid,count(account) cishu,sum(account) tou from 05b_1tenderfinal   where orguid=0 and bid <> 10000 GROUP BY uid) h on a.uid=h.uid
														LEFT JOIN
														(select b1.uid 用户ID,"APP运营部" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "YY"
														union all
														select b1.uid 用户ID,"PC运营部" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "PY"
														union all
														select b1.uid 用户ID,"WAP运营部" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "WY"
														union all
														select b1.uid 用户ID,"上海" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "SH"
														union all
														select b1.uid 用户ID,"PC" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "JS"
														union all
														select b1.uid 用户ID,"杭州部" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "HZ"
														union all
														select b1.uid 用户ID,"PC" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "DT"
														union all
														select b1.uid 用户ID,"平台总部" 所属部门 FROM 01u_0base b1 JOIN 02c_1r_uid_rid e ON b1.uid = e.uid WHERE e.rid = 12 and SUBSTR(UPPER(b1.un) FROM 1 FOR 2 ) = "ZZ") bu
														on c.uid_kefu=bu.用户ID
														where  DATE(a.recover_times) = DATE_SUB(curdate(),INTERVAL 1 DAY)
														and c.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
														and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
									) t1
					) t2
	) t3
	GROUP BY t3.uid
) t4
GROUP BY t4.geduan















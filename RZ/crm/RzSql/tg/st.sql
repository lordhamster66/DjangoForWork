SELECT  a.uid,b.uname,b.mobile,b.time_h,case when s.`status` = 1 and s.is_authentication = 1 and s.is_tied_card = 1 then s.update_time else "" end update_time,
q.name,a.first_account account,a.first_time tz_time,a.time_limit qixian,a.name bd_name
from rzjf_bi.rzjf_first_invest_recorde a
INNER JOIN 01u_0info b on a.uid = b.uid
INNER JOIN 01u_0qudao q on a.uid = q.uid
LEFT JOIN rz_cg_user_ext s on a.uid = s.uid
where b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.first_time > "{start_time}"
and a.first_time < DATE_ADD("{end_time}",INTERVAL 1 day)
and q.name in ({name})
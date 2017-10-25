SELECT a.uid,b.uname,b.mobile,b.time_h,a.update_time,q.name,st.first_account account,st.first_time tz_time,st.time_limit qixian,st.name bd_name
from rz_cg_user_ext a
INNER JOIN 01u_0info b on a.uid = b.uid
INNER JOIN 01u_0qudao q on a.uid = q.uid
LEFT JOIN rzjf_bi.rzjf_first_invest_recorde st on a.uid = st.uid
where a.`status` = 1
and a.is_authentication = 1
and a.is_tied_card = 1
and b.uid_kefu not in (145854,73170,73195,73721,112103,244848,276009,304525,1,181135,757996,910859)
and a.uid not in (740,181,827,1008,1444,1451,1435,1452,6420,7127,11336,11350,11353,11871,12135,5528,18710,19104,19103,27632,6094,12668,14288)
and a.update_time > "{start_time}"
and a.update_time < DATE_ADD("{end_time}",INTERVAL 1 day)
and q.name in ({name})

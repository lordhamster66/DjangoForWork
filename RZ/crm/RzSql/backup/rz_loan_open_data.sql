insert into rz_loan_open_data
(`id`,
`bid`,
`temp_uid`,
`create_time`,
`classify`,
`md5_uid`,
`original_uid`
)
select `id`,
`bid`,
`temp_uid`,
`create_time`,
`classify`,
`md5_uid`,
`original_uid` from wd.rz_loan_open_data
where create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 2 DAY),"%Y-%m-%d 23:59:59") and create_time <= DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:59:59");

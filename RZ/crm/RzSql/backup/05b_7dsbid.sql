insert into 05b_7dsbid (`bid`,
`uid`,
`cid`,
`time_h`,
`isxs`,
`opentime`,
`opentimeds`,
`STATUS`,
`verify_time`
) select `bid`,
`uid`,
`cid`,
`time_h`,
`isxs`,
`opentime`,
`opentimeds`,
`STATUS`,
`verify_time`
 from wd.05b_7dsbid
where time_h > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and time_h <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");

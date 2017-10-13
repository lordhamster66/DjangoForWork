insert into 11_auth (`uid`,
`username`,
`password`,
`token`,
`appname`
) select `uid`,
`username`,
`password`,
`token`,
`appname`
 from wd.11_auth WHERE uid > (SELECT max(uid) from 11_auth);
insert into 11_auth select * from wd.11_auth WHERE uid > (SELECT max(uid) from 11_auth);
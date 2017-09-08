#! /usr/bin/env python
# -*- coding: utf-8 -*-
# __author__ = "Breakering"
# Date: 2017/9/8
for i in range(32):
    f = open("temp/rz_borrow_tender_{i}.sql".format(i=i), "w")
    f.write("""insert into rz_borrow_tender_{i} select * from new_wd.rz_borrow_tender_{i}
where create_time > DATE_FORMAT(DATE_SUB(curdate(),INTERVAL 1 DAY),"%Y-%m-%d 23:30:00") and create_time <= DATE_FORMAT(curdate(),"%Y-%m-%d 23:30:00");
""".format(i=i))
    f.close()

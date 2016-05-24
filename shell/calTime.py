#! /usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import time


#timestring = "2015-02-02 02:02:03"
timestring = sys.argv[1]
timestamp = time.mktime(time.strptime(timestring,'%Y-%m-%d %H:%M:%S'))
print timestamp
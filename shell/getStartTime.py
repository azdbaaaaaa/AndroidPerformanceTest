#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import subprocess

def readFile(filename):
    print "读取文件" + filename
    try:
        f = open(filename).read()
        return f
    except Exception, e:
        print "读取文件内容失败:{}".format(e)
        return ""

def writeToFile(filename,string):
    # logSave("打开文件" + filename)
    print "打开文件" + filename
    f = open(filename,'a')
    try:
        # logSave("开始写入文件" + filename)
        print "开始写入文件" + filename
        f.write(string+"\n")
        # print "写入" + string + "成功"
    except:
        # logSave("写入" + string + "失败:" + str(e),"error")
        print "写入" + string + "失败"
    finally:
        # logSave("关闭文件")
        print "关闭文件"
        f.close()

filename = "/Users/jimmy_zhou/Desktop/android/shell/test.txt"
disPlayTxt = "/Users/jimmy_zhou/Desktop/android/myresult/DisplayTime.txt"

mmbangActivityDict = {
	"启动页面":"SplashActivity",
	"主页面":"MainActivity",

	"登录页面":"ActivityLogin",
	# "短信登录页":"ActivityPhoneCodeLogin",
	# "找回密码":"ActivityFindPassword",

	# "视频播放页":"VideoPlayerActivity",
	# "我的帮":"MyMMBangActivity",

	"推荐关注":"RecommendFollowActivity",
	"他人信息页":"PersonalActivity",
	"消息":"BangMessageActivity",
	"发帖":"",

	"帮页面":"BangItemListActivity",
	"帖子详情页":"TopicDetailListActivity",
	# "帮信息页面":"BangInfoActivity",
				
	"收藏":"BangItemListActivity",
	"我的话题":"BangItemListActivity",  	
	"关注":"FriendsActivity",				  	
	"粉丝":"FriendsActivity",				  	
	"设置页面":"SettingActivity"
}


bbtreeActivityDict = {
	"启动页面":"MainActivity",
	"主页面":"SailfishActivity",

	"登录页面":"LoginActivity",

	"宝宝树推荐":"RecommendActivity",
	"他人信息页":"CenterActivity",
	"消息":"MessageCenterActivity",
	"发帖":"TopicPostActivity",

	"帮页面":"NewTopicListActivity",
	"帖子详情页":"TopicDetailActivity",

	"收藏":"MyFavoritesActivity",
	"发表的帖子":"PostTopicListActivity",
	"关注":"FollowerAndFunsActivity",
	"粉丝":"FollowerAndFunsActivity",
	"设置页面":"SettingActivity"
}

# for x in mmbangActivityDict:
# 	print mmbangActivityDict[x]

def grep(filename, arg):
	process = subprocess.Popen(['grep', '-n', arg, filename], stdout=subprocess.PIPE)
	stdout, stderr = process.communicate()
	return stdout, stderr

print grep(filename, "SplashActivity")
# print open(disPlayTxt).readline(100)

# print readFile(disPlayTxt)
# os.system("ls")
# print mmbangActivityDict["启动页面"]
# print len(mmbangActivityDict)
# writeToFile(filename,mmbangActivityDict["启动页面"])




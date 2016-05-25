#!/bin/bash

rootPath=`dirname $(pwd)`
logDirPath=$rootPath/"log"

echo "请输入需要测试的apk"
echo "1.妈妈帮"
echo "2.宝宝树"

# read choice
choice=1
echo "请输入apk的版本号"
# read versionName
versionName="3.11.4"

if [[ $choice = 1 ]]; then
	packageName="com.yaya.mmbang"
	# DisplayTimeLog=$logPath/"DisplayedTime_com.yaya.mmbang3.12.3.log"
elif [[ $choice = 2 ]]; then
	packageName="com.babytree.apps.pregnancy"
	# DisplayTimeLog=$logPath/"DisplayedTime_com.babytree.apps.pregnancy6.6.1.log"
fi

DisplayTimeLog=$logDirPath/"DisplayedTime_"$packageName$versionName".log"

# if [[ -e $DisplayTimeLog ]]; then
# 	rm -rf $DisplayTimeLog
# fi

adb shell logcat -c
echo "111"
adb shell logcat -v time -s ActivityManager >>$DisplayTimeLog

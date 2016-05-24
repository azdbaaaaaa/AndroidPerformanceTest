#!/bin/bash

rootPath=`dirname $(pwd)`
resultPath=$rootPath/"result"

echo "请输入需要测试的apk"
echo "1.妈妈帮"
echo "2.宝宝树"

read choice

if [[ $choice = 1 ]]; then
	echo "妈妈帮"
	packageName="com.yaya.mmbang"
	DisplayTimeLog=$resultPath/"MMBangDisplayTime.log"
elif [[ $choice = 2 ]]; then
	echo "宝宝树"
	packageName="com.babytree.apps.pregnancy"
	DisplayTimeLog=$resultPath/"BBtreeDisplayTime.log"
fi

# if [[ -e $DisplayTimeLog ]]; then
# 	rm -rf $DisplayTimeLog
# fi

adb shell logcat -c
echo "111"
adb shell logcat -v time -s ActivityManager >>$DisplayTimeLog

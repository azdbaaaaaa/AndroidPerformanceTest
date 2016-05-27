#!/bin/bash

# rootPath=`dirname $(pwd)`
# packageName="com.yaya.mmbang"
# mainActivity="com.yaya.mmbang.activity.SplashActivity"
# versionName="3.12.3"
# apkFilePath=$rootPath"/apk/MMBangRelease_xiaomi_m.apk"
# apkFileSDCardPath="/sdcard/mmbang/apk/MMBangRelease_xiaomi_m.apk"
# startTimeFilePath=$rootPath"/myresult/StartTime.csv"
# exeTimes=2

#启动时间
echo "===================测试启动时间开始======================="


function uninstallApp(){
	echo "-----开始卸载app:[$packageName]-----"
	adb uninstall $packageName
}

function installApp(){
	echo "-----开始安装app:[$packageName]-----"
	adb shell pm install $apkFileSDCardPath
}

function getFirstColdStartTime(){
	sleep 2
	# echo "----开始获取首次安装冷启动时间-----"
	TotalTime=`adb shell am start -W $packageName/$mainActivity | grep -ai TotalTime|awk -F ' ' '{print $2}'|tr -d "\r"`
	# WaitTime=`adb shell am start -W $packageName/$mainActivity | grep -ai WaitTime|awk -F ' ' '{print $2}'|tr -d "\r"`
	echo $TotalTime",""\c">>$startTimeFilePath
	# echo $WaitTime",""\c">>$startTimeFilePath

	# echo "----获取首次安装冷启动时间完成:$WaitTime-----"
}

function getWarmStartTime(){
	# echo "-----开始获取热启动时间-----"
	sleep 2
	adb shell input keyevent KEYCODE_BACK
	adb shell input keyevent KEYCODE_BACK
	sleep 2
	TotalTime=`adb shell am start -W $packageName/$mainActivity | grep -ai TotalTime|awk -F ' ' '{print $2}'|tr -d "\r"`
	# WaitTime=`adb shell am start -W $packageName/$mainActivity | grep -ai WaitTime|awk -F ' ' '{print $2}'|tr -d "\r"`
	echo $TotalTime>>$startTimeFilePath
	# echo $WaitTime>>$startTimeFilePath

	# echo "-----获取热启动时间完成:$WaitTime-----"
}

function getMaxAndAvg(){
	echo "-----开始计算最大值和平均值-----"
	firstColdStartTime=`awk -F, '/^[0-9]/{sum+=$2;if($2>Max)Max=$2}END{print ",AVG="sum/(NR-2)"Max="Max}' $startTimeFilePath`
	echo $firstColdStartTime"\c" >>$startTimeFilePath
	warmStartTime=`awk -F, '/^[0-9]/{sum+=$3;if($3>Max)Max=$3}END{print ",AVG="sum/(NR-2)"Max="Max}' $startTimeFilePath`
	echo $warmStartTime >>$startTimeFilePath
	# resultString=`awk '{Sum+=$1;if($1>Max)Max=$1}END{print "AVG="Sum/NR"\nMax="Max}' $tempFilePath`
	# echo $resultString
}

echo "-----开始写入文件头部信息-----"
echo ",$packageName,$versionName">>$startTimeFilePath
echo ",FirstColdStartTime(ms),WarmStartTime(ms)" >>$startTimeFilePath

adb push $apkFilePath $apkFileSDCardPath

for (( i = 1; i <= $exeTimes; i++ ))
do
	echo "循环开始"
	#卸载app
	uninstallApp

	#安装app
	installApp
	
	# write line number
	echo "$i,""\c" >>$startTimeFilePath

	# #首次安装--冷启动
	getFirstColdStartTime

	# #非首次安装--冷启动
	# toBeDone

	#热启动
	getWarmStartTime
	echo "循环结束"
	sleep 2
done

uninstallApp
echo "======================测试启动时间结束========================="

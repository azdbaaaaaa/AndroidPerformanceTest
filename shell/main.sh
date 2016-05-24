#! /bin/bash

# 目录地址
export rootPath=`dirname $(pwd)`
export apkPath=$rootPath/"apk"
export htmlPath=$rootPath/"html"
export resultPath=$rootPath/"result"
export shellPath=$rootPath/"shell"
export logPath=$rootPath/"log"
export csvDirPath=$rootPath/"csv"
export htmlDemoDirPath=$htmlPath/"htmlDemo"

# html demo模板地址
export coldStartTimeHtmlDemoPath=$htmlDemoDirPath/"ColdStartTimeDemo.html"
export warmStartTimeHtmlDemoPath=$htmlDemoDirPath/"WarmStartTimeDemo.html"
export memoryHtmlDemoPath=$htmlDemoDirPath/"MemoryDemo.html"
export cpuHtmlDemoPath=$htmlDemoDirPath/"CPUDemo.html"

# 设置运行脚本配置内容
# ##################################################################################
# ##################################################################################
# 是否需要生产总的性能报告
export isNeedTotalReport=true
#
#
# 以下变量主要用于 getStartTime.sh
# 目标测试包名
# export apkName="MMBangRelease_xiaomi_m.apk"
export apkName="BBtree.apk"
# 目标测试包地址
export apkFilePath=$apkPath/$apkName
# PUSH到手机端路径
export apkFileSDCardPath="/sdcard/mmbang/apk/"$apkName
# 执行次数
export exeTimes=5
# 
# 以下变量主要用于 monkeyTest.sh
# monkey操作间隔时间
export thinkTime=500
# seed值
export seed=2
# 执行的操作次数
export eventNumber=1000
# 设置采集数据间隔时间，单位:s
export sleepTime=3
# 
# 
# 
# 
# ##################################################################################
# ##################################################################################

# 获取版本信息和时间；确定结果保存路径文件夹地址
datenow=`date +'%Y%m%d%H%M%S'`
#
export packageName=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f2`
export versionCode=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f4`
export versionName=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f6`
export mainActivity=`aapt dump badging $apkFilePath | grep launchable-activity | head -n1 | cut -d "'" -f2`
#
#
#########################################################################
# 结果目录地址
export resultDirName=$packageName"_"$versionName"_"$datenow
export resultDirPath=$resultPath/$resultDirName
export resultDirHtmlPath=$resultDirPath/"html"
export resultDirLogPath=$resultDirPath/"log"
export resultDirTempPath=$resultDirPath/"temp"
export resultDirResultPath=$resultDirPath/"result"

# 结果文件地址
# getStartTime.sh	StartTimeCSV2HTML.sh
export startTimeFilePath=$resultDirResultPath/"StartTime.csv"
export coldStartTimeHtmlPath=$resultDirHtmlPath/"ColdStartTime.html"
export warmStartTimeHtmlPath=$resultDirHtmlPath/"WarmStartTime.html"
# monkeyTest.sh Performance2HTML.sh
export monkeyLogFilePath=$resultDirLogPath/"monkeyLog.log"
export logcatLogFilePath=$resultDirLogPath/"logcat.log"
export performanceFilePath=$resultDirResultPath/"performance.csv"
export gfxinfoFilePath=$resultDirResultPath/"gfxinfo.csv"
export gfxinfo_temp=$resultDirTempPath/"gfxinfo_temp.txt"
export memoryHtmlFilePath=$resultDirHtmlPath/"Memory.html"
export cpuHtmlFilePath=$resultDirHtmlPath/"CPU.html"

#########################################################################



# 创建文件夹及其子目录文件夹
if [[ ! -d $resultDirPath ]]; then
	mkdir $resultDirPath
fi

if [[ ! -d $resultDirHtmlPath ]]; then
	mkdir $resultDirHtmlPath
fi

if [[ ! -d $resultDirLogPath ]]; then
	mkdir $resultDirLogPath
fi

if [[ ! -d $resultDirTempPath ]]; then
	mkdir $resultDirTempPath
fi

if [[ ! -d $resultDirResultPath ]]; then
	mkdir $resultDirResultPath
fi

echo "选择需要测试的脚本:"
echo "a.monkey测试（含性能）"
echo "b.启动时间测试"
echo "c.页面加载时间测试"
echo "d.启动时间测试+monkey测试（含性能）"
echo "e.ProcessDisplayTime"
read choice

if [[ $choice = "a" ]]; then
	#statements
	echo "you have chosen opition a"

	sh $shellPath/"monkeyTest.sh"
	sh $shellPath/"Performance2HTML.sh"
elif [[ $choice = "b" ]]; then
	#statements
	echo "you have chosen opition b"

	sh $shellPath/"getStartTime.sh"
	sh $shellPath/"StartTimeCSV2HTML.sh"
elif [[ $choice = "c" ]]; then
	#statements
	echo "you have chosen opition c"
	echo "opition c is not ready"
elif [[ $choice = "d" ]]; then
	echo "you have chosen opition d"

	sh $shellPath/"getStartTime.sh"
	sh $shellPath/"StartTimeCSV2HTML.sh"
	sh $shellPath/"monkeyTest.sh"
	sh $shellPath/"Performance2HTML.sh"
elif [[ $choice = "e" ]]; then
	echo "you have chosen opition e"

	sh $shellPath/"ProcessDisplayTime.sh"
else
	echo "输入的内容不合法"
fi

# adb shell input keyevent KEYCODE_HOME

# if [[ $isNeedTotalReport = true ]]; then
# 	sleep 2
# 	cp $startTimeFilePath $csvDirPath/"StartTime_"$packageName$versionName".csv"
# 	# sh $shellPath/generateTotalReport
# fi

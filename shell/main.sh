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
# export htmlTempDirPath=$htmlPath/"htmlTemp"
# export htmlReportDirPath=$htmlPath/"report"
# html demo模板地址
export coldStartTimeHtmlDemoPath=$htmlDemoDirPath/"ColdStartTimeDemo.html"
export warmStartTimeHtmlDemoPath=$htmlDemoDirPath/"WarmStartTimeDemo.html"
export memoryHtmlDemoPath=$htmlDemoDirPath/"MemoryDemo.html"
export cpuHtmlDemoPath=$htmlDemoDirPath/"CPUDemo.html"
export reportDemoFilePath=$htmlDemoDirPath/"ReportDemo.html"
export flowDemoFilePath=$htmlDemoDirPath/"FlowDemo.html"
# 设置运行脚本配置内容
# ##################################################################################
# ##################################################################################
# 以下变量主要用于 getStartTime.sh
# 启动时间测试的执行次数
export exeTimes=20
# 以下变量主要用于 monkeyTest.sh
# monkey操作间隔时间
export thinkTime=500
# seed值
export seed=$RANDOM
# 执行的操作次数
export eventNumber=3000
# 设置采集数据间隔时间，单位:s
export sleepTime=3
# 
# 
# 
# 
# ##################################################################################
# ##################################################################################

ls $apkPath | while read apkName
do
	################################################
	# 以下代码执行单个应用，注释后可执行apk文件夹下所有apk
	# if [[ ! $apkName = "mmbang_svn_test-3.13.0-201605241831.apk" ]]; then
	# 	continue
	# fi
	################################################
	# 遍历apk
	export apkName
	echo "开始测试"$apkName

	# 目标测试包地址
	export apkFilePath=$apkPath/$apkName
	# PUSH到手机端路径
	export apkFileSDCardPath="/sdcard/mmbang/apk/"$apkName
	# 获取版本信息和时间；确定结果保存路径文件夹地址
	datenow=`date +'%Y%m%d%H%M%S'`
	#
	export packageName=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f2`
	# export versionCode=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f4`
	export versionName=`aapt dump badging $apkFilePath | grep package | head -n1 | cut -d "'" -f6`
	export mainActivity=`aapt dump badging $apkFilePath | grep launchable-activity | head -n1 | cut -d "'" -f2`
	export phoneAPIVersion=`adb shell cat /system/build.prop | grep ro.build.version.release | cut -d "=" -f2 | tr -d " "`
	export phoneBrand=`adb shell cat /system/build.prop | grep ro.product.brand | cut -d "=" -f2 | tr -d " "`
	export phoneModel=`adb shell cat /system/build.prop | grep ro.product.model | cut -d "=" -f2 | tr -d " "`
	#
	#
	#########################################################################
	# 结果目录地址
	export resultDirName=$packageName"_"$versionName
	export resultApkPath=$resultPath/$resultDirName
	export resultDirPath=$resultApkPath/$datenow
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
	export performanceTempFilePath=$resultDirResultPath/"performance.txt"
	export performanceFilePath=$resultDirResultPath/"performance.csv"
	export gfxinfoFilePath=$resultDirResultPath/"gfxinfo.csv"
	export gfxinfo_temp=$resultDirTempPath/"gfxinfo_temp.txt"

	export memoryHtmlFilePath=$resultDirHtmlPath/"Memory.html"
	export cpuHtmlFilePath=$resultDirHtmlPath/"CPU.html"
	export flowHtmlFilePath=$resultDirHtmlPath/"Flow.html"
	#########################################################################
	# 创建文件夹及其子目录文件夹

	if [[ ! -d $resultApkPath ]]; then
		mkdir $resultApkPath
	fi

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

	sh $shellPath/"getStartTime.sh"
	sh $shellPath/"StartTimeCSV2HTML.sh"
	sh $shellPath/"monkeyTest.sh"
	sh $shellPath/"Performance2HTML.sh"

	cp $startTimeFilePath $csvDirPath/"StartTime_"$packageName$versionName".csv"
	sh $shellPath/"generateTotalReport.sh" $resultDirPath

	adb shell input keyevent KEYCODE_HOME

	echo "结束测试"$apkName
done



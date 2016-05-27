#! /bin/bash
# $1: resultPath下的文件夹（从main.sh启动可不输入，取父进程的定义的地址）
#
#
# rootPath=`dirname $(pwd)`
# apkPath=$rootPath/"apk"
# htmlPath=$rootPath/"html"
# resultPath=$rootPath/"result"
# shellPath=$rootPath/"shell"
# logPath=$rootPath/"log"
# csvDirPath=$rootPath/"csv"
# htmlDemoDirPath=$htmlPath/"htmlDemo"

reportDemoFilePath=$htmlDemoDirPath/"ReportDemo.html"


resultDirPath=$1
# echo $resultDirPath

resultDirHtmlPath=$resultDirPath/"html"
resultDirLogPath=$resultDirPath/"log"
resultDirTempPath=$resultDirPath/"temp"
resultDirResultPath=$resultDirPath/"result"

reportTempFilePath=$resultDirHtmlPath/"reportTemp.html"
reportFilePath=$resultDirHtmlPath/"report.html"

coldStartTimeHtmlPath=$resultDirHtmlPath/"ColdStartTime.html"
warmStartTimeHtmlPath=$resultDirHtmlPath/"WarmStartTime.html"
memoryHtmlFilePath=$resultDirHtmlPath/"Memory.html"
cpuHtmlFilePath=$resultDirHtmlPath/"CPU.html"
flowHtmlFilePath=$resultDirHtmlPath/"Flow.html"

displayTimeHtmlFilePath=$htmlPath/"DisplayTime.html"

function getHighchartsCode(){
	htmlFilePath=$1
	if [[ -f $htmlFilePath ]]; then
		startLine=`cat $htmlFilePath | grep -n "\\$(function ()" | head -n 1 | cut -d ":" -f1`
		endLineTemp=`cat $htmlFilePath | grep -n "</head>" | head -n 1 | cut -d ":" -f1`
		endLine=$((endLineTemp-2))
		cat $htmlFilePath | head -n $endLine | tail -n $(($endLineTemp-$startLine-1))
	fi
}

function getMyColdTime(){
	csvFile=$1

	appName=`cat $csvFile | head -n 1 | cut -d "," -f 2`
	appVersion=`cat $csvFile | head -n 1 | cut -d "," -f 3`

	coldDataString=""
	warmDataString=""

	while read line
	do
		temp=`echo $line | cut -d "," -f 1`
		if [[ $temp =~ [0-9] ]]; then
			coldData=`echo $line | awk -F, '{print $2}'`
			warmData=`echo $line | awk -F, '{print $3}'`
			coldDataString=$coldDataString","$coldData
			warmDataString=$warmDataString","$warmData
			# echo $coldData
			# echo $warmData
		fi
		# export $coldDataString
	done < $csvFile

	myColdTime="{name: '"$appName$appVersion"',data: [0"$coldDataString"]},"
	echo $myColdTime
}

function getMyWarmTime(){
	csvFile=$1

	appName=`cat $csvFile | head -n 1 | cut -d "," -f 2`
	appVersion=`cat $csvFile | head -n 1 | cut -d "," -f 3`

	coldDataString=""
	warmDataString=""

	while read line
	do
		temp=`echo $line | cut -d "," -f 1`
		if [[ $temp =~ [0-9] ]]; then
			coldData=`echo $line | awk -F, '{print $2}'`
			warmData=`echo $line | awk -F, '{print $3}'`
			coldDataString=$coldDataString","$coldData
			warmDataString=$warmDataString","$warmData
			# echo $coldData
			# echo $warmData
		fi
		# export $coldDataString
	done < $csvFile

	myWarmTime="{name: '"$appName$appVersion"',data: [0"$warmDataString"]},"
	echo $myWarmTime
}

if [[ -f $reportTempFilePath ]]; then
	rm $reportTempFilePath
fi

if [[ -f $reportFilePath ]]; then
	rm $reportFilePath
fi


# 渲染highcharts部分图表
cat -n $reportDemoFilePath | while read line
do
	l=`echo $line | awk '{print $1}'`
	if [[ $l = 11 ]]; then
		getHighchartsCode $coldStartTimeHtmlPath >>$reportTempFilePath
		getHighchartsCode $warmStartTimeHtmlPath >>$reportTempFilePath
		getHighchartsCode $memoryHtmlFilePath >>$reportTempFilePath
		getHighchartsCode $cpuHtmlFilePath >>$reportTempFilePath
		# echo $displayTimeHtmlFilePath
		getHighchartsCode $displayTimeHtmlFilePath >>$reportTempFilePath
		getHighchartsCode $flowHtmlFilePath >>$reportTempFilePath
	elif [[ $line =~ '<td id="testphone">' ]]; then
		echo '<td id="testphone">'$phoneBrand$phoneModel'</td>' >>$reportTempFilePath
	elif [[ $line =~ '<td id="androidAPI">' ]]; then
		echo '<td id="androidAPI">'$phoneAPIVersion'</td>' >>$reportTempFilePath
	elif [[ $line =~ '<td id="packageName">' ]]; then
		echo '<td id="packageName">'$packageName'</td>' >>$reportTempFilePath
	elif [[ $line =~ '<td id="versionName">' ]]; then
		echo '<td id="versionName">'$versionName'</td>' >>$reportTempFilePath
	else
		# echo $l
		cat $reportDemoFilePath | head -n $l | tail -n 1 >>$reportTempFilePath
	fi
done

# 渲染更新启动时间以及主要页面加载时间部分的数据
cat -n $reportTempFilePath | while read line
do
	l=`echo $line | awk '{print $1}'`
	if [[ $l = 61 ]]; then
		# 渲染ColdStartTime部分series数据
		ls $csvDirPath | while read line
		do
			if [[ $line =~ "StartTime" ]]; then
				echo `getMyColdTime $csvDirPath/$line`"\c" >>$reportFilePath
			fi
		done
		# echo -e "\n"
	elif [[ $l = 115 ]]; then
		# 渲染WarmStartTime部分series数据
		ls $csvDirPath | while read line
		do
			if [[ $line =~ "StartTime" ]]; then
				echo `getMyWarmTime $csvDirPath/$line`"\c" >>$reportFilePath
			fi
		done
	elif [[ $line =~ '<td id="testphone">' ]]; then
		echo '<td id="testphone">'$phoneBrand$phoneModel'</td>' >>$reportFilePath
	elif [[ $line =~ '<td id="androidAPI">' ]]; then
		echo '<td id="androidAPI">'$phoneAPIVersion'</td>' >>$reportFilePath
	elif [[ $line =~ '<td id="packageName">' ]]; then
		echo '<td id="packageName">'$packageName'</td>' >>$reportFilePath
	elif [[ $line =~ '<td id="versionName">' ]]; then
		echo '<td id="versionName">'$versionName'</td>' >>$reportFilePath
	else
		cat $reportTempFilePath | head -n $l | tail -n 1 >>$reportFilePath
	fi
done

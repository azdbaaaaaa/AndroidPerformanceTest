#! /bin/bash
# $1: resultPath下的文件夹（从main.sh启动可不输入，取父进程的定义的地址）
#
#
rootPath=`dirname $(pwd)`
apkPath=$rootPath/"apk"
htmlPath=$rootPath/"html"
resultPath=$rootPath/"result"
shellPath=$rootPath/"shell"
logPath=$rootPath/"log"
csvDirPath=$rootPath/"csv"
htmlDemoDirPath=$htmlPath/"htmlDemo"
htmlTempDirPath=$htmlPath/"htmlTemp"
reportDirHtmlPath=$htmlPath/"report"

reportDemoFilePath=$htmlDemoDirPath/"reportDemo.html"
reportTempFilePath=$reportDirHtmlPath/"reportTemp.html"
reportFilePath=$reportDirHtmlPath/"report.html"



coldStartTimeHtmlPath=$htmlTempDirPath/"ColdStartTime.html"
warmStartTimeHtmlPath=$htmlTempDirPath/"WarmStartTime.html"
memoryHtmlFilePath=$htmlTempDirPath/"Memory.html"
cpuHtmlFilePath=$htmlTempDirPath/"CPU.html"

function getHighchartsCode(){
	htmlFilePath=$1
	startLine=`cat $htmlFilePath | grep -n "\\$(function ()" | head -n 1 | cut -d ":" -f1`
	endLineTemp=`cat $htmlFilePath | grep -n "</head>" | head -n 1 | cut -d ":" -f1`
	endLine=$((endLineTemp-2))
	cat $htmlFilePath | head -n $endLine | tail -n $(($endLineTemp-$startLine-1))
	# echo $startLine
	# echo $endLine
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
	else
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
				echo -n `getMyColdTime $csvDirPath/$line` >>$reportFilePath
			fi
		done
		# echo -e "\n"
	elif [[ $l = 115 ]]; then
		# 渲染WarmStartTime部分series数据
		ls $csvDirPath | while read line
		do
			if [[ $line =~ "StartTime" ]]; then
				echo -n `getMyWarmTime $csvDirPath/$line` >>$reportFilePath
			fi
		done
		# echo -e "\n"
	else
		cat $reportTempFilePath | head -n $l | tail -n 1 >>$reportFilePath
	fi
done

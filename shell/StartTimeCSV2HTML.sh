#! /bin/bash

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

function renderHtml(){
#	$1:coldStartTimeHtmlDemoPath/warmStartTimeHtmlDemoPath
#	$2:coldStartTimeHtmlPath/warmStartTimeHtmlPath
#	$3:getMyColdTime/getMyWarmTime
	cat -n $1 | while read line
	do
		l=`echo $line | awk '{print $1}'`
		if [[ $l = 62 ]]; then
			$3 $startTimeFilePath >> $2
			# cat $tempColdFile >> $coldStartTimeHtmlPath
		else
			echo `cat $1 | head -n $l | tail -n 1` >> $2
		fi
	done
}


renderHtml $coldStartTimeHtmlDemoPath $coldStartTimeHtmlPath getMyColdTime
renderHtml $warmStartTimeHtmlDemoPath $warmStartTimeHtmlPath getMyWarmTime

# cat -n $coldStartTimeHtmlDemoPath | while read line
# do
# 	l=`echo $line | awk '{print $1}'`
# 	if [[ $l = 62 ]]; then
# 		getMyColdTime $startTimeFilePath >> $coldStartTimeHtmlPath
# 		# cat $tempColdFile >> $coldStartTimeHtmlPath
# 	else
# 		echo `cat $coldStartTimeHtmlDemoPath | head -n $l | tail -n 1` >> $coldStartTimeHtmlPath
# 	fi
# done

# cat -n $warmStartTimeHtmlDemoPath | while read line
# do
# 	l=`echo $line | awk '{print $1}'`
# 	if [[ $l = 62 ]]; then
# 		getMyWarmTime $startTimeFilePath >> $warmStartTimeHtmlPath
# 		# cat $tempWarmFile >> $warmStartTimeHtmlPath
# 	else
# 		echo `cat $warmStartTimeHtmlDemoPath | head -n $l | tail -n 1` >> $warmStartTimeHtmlPath
# 	fi
# done





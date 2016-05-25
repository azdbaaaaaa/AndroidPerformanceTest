#! /bin/bash

rootPath=`dirname $(pwd)`
apkPath=$rootPath/"apk"
htmlPath=$rootPath/"html"
resultPath=$rootPath/"result"
shellPath=$rootPath/"shell"
logPath=$rootPath/"log"
csvDirPath=$rootPath/"csv"
htmlDemoDirPath=$htmlPath/"htmlDemo"

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

DisplayTimeLog=$logPath/"DisplayedTime_"$packageName$versionName".log"

# MY_Date=`date +'%Y%m%d_%H%M%S'`

# DisplayTimeResult=$resultPath/"DisplayTime_"$MY_Date".csv"
DisplayTimeCsvPath=$csvDirPath/"DisplayedTime_"$packageName$versionName".csv"
DisplayTimeHtmlDemoPath=$htmlPath/"htmlDemo"/"DisplayTimeDemo.html"
DisplayTimeHtmlPath=$htmlPath/"DisplayTime.html"

DisplayTimeDataTempPath=$htmlPath/"DisplayTimedataTemp.txt"
DisplayTimeActivityTempPath=$htmlPath/"DisplayTimeActivityTemp.txt"

if [[ -f $DisplayTimeCsvPath ]]; then
	rm $DisplayTimeCsvPath
fi

if [[ -f $DisplayTimeHtmlPath ]]; then
	rm $DisplayTimeHtmlPath
fi

if [[ -f $DisplayTimeDataTempPath ]]; then
	rm $DisplayTimeDataTempPath
fi

if [[ -f $DisplayTimeActivityTempPath ]]; then
	rm $DisplayTimeActivityTempPath
fi


nameList=("启动页面" "主页面" "登录页面" "推荐关注" "他人信息页" "消息页面" "发帖页面" "具体帮页面" "帖子详情页" "收藏页面" "我的帖子页面" "关注页面" "粉丝页面" "设置页面")

mmbangActivityList=("SplashActivity" "MainActivity" "ActivityLogin" "RecommendFollowActivity" "PersonalActivity" \
	"BangMessageActivity" "CreateTopicInputActivity" "BangItemListActivity" "TopicDetailListActivity" "BangItemListActivity" \
	"BangItemListActivity" "FriendsActivity" "FriendsActivity" "SettingActivity")
bbtreeActivityList=("MainActivity" "SailfishActivity" "LoginActivity" "RecommendActivity" "CenterActivity" "MessageCenterActivity" \
	"TopicPostActivity" "NewTopicListActivity" "TopicDetailActivity" "MyFavoritesActivity" "PostTopicListActivity" \
	"FollowerAndFunsActivity" "FollowerAndFunsActivity" "SettingActivity")

echo ,$packageName,$versionName>>$DisplayTimeCsvPath
# echo ,"页面名称","Activity展示时间">>$DisplayTimeCsvPath
echo "页面名称,Activity,StartTime,EndTime,TotalTime(ms)" >>$DisplayTimeCsvPath
for (( i = 0; i < ${#nameList[@]}; i++ )); do
# for (( i = 0; i < 1; i++ )); do
	# echo $i
	if [[ $packageName = "com.yaya.mmbang" ]]; then
		echo $(($i+1))",\c">>$DisplayTimeCsvPath
		echo ${nameList[$i]}",\c">>$DisplayTimeCsvPath
		echo ${mmbangActivityList[$i]}",\c">>$DisplayTimeCsvPath
		myStartTime=`cat $DisplayTimeLog | grep ${mmbangActivityList[$i]} | grep "START" | tail -n1 | cut -d " " -f1,2`
		myStartTimeSec=`echo $myStartTime | cut -d "." -f 1`
		myStartTimeMsec=`echo $myStartTime | cut -d "." -f 2`
		myYear=`date +%Y`
		myStartTimeSec=$myYear"-"$myStartTimeSec
		echo $myStartTimeSec.$myStartTimeMsec",\c">>$DisplayTimeCsvPath
		myStartTimeSec=`python calTime.py "$myStartTimeSec"`
		myStartTimeSec=`echo $myStartTimeSec | cut -d '.' -f 1`
		# echo "$myStartTimeSec*1000+$myStartTimeMsec" | bc

		myEndTime=`cat $DisplayTimeLog | grep ${mmbangActivityList[$i]} | grep "Displayed" | tail -n1 | cut -d " " -f1,2`
		myEndTimeSec=`echo $myEndTime | cut -d "." -f 1`
		myEndTimeMsec=`echo $myEndTime | cut -d "." -f 2`
		myYear=`date +%Y`
		myEndTimeSec=$myYear"-"$myEndTimeSec
		echo $myEndTimeSec.$myEndTimeMsec",\c">>$DisplayTimeCsvPath
		myEndTimeSec=`python calTime.py "$myEndTimeSec"`
		myEndTimeSec=`echo $myEndTimeSec | cut -d "." -f 1`
		# echo "$myEndTimeSec*1000+$myEndTimeMsec" | bc

		echo "$myEndTimeSec*1000+$myEndTimeMsec-$myStartTimeSec*1000-$myStartTimeMsec" | bc>>$DisplayTimeCsvPath
	elif [[ $packageName = "com.babytree.apps.pregnancy" ]]; then
		echo $(($i+1))",\c">>$DisplayTimeCsvPath
		echo ${nameList[$i]}",\c">>$DisplayTimeCsvPath
		echo ${bbtreeActivityList[$i]}",\c">>$DisplayTimeCsvPath
		myStartTime=`cat $DisplayTimeLog | grep ${bbtreeActivityList[$i]} | grep "START" | tail -n1 | cut -d " " -f1,2`
		myStartTimeSec=`echo $myStartTime | cut -d "." -f 1`
		myStartTimeMsec=`echo $myStartTime | cut -d "." -f 2`
		myYear=`date +%Y`
		myStartTimeSec=$myYear"-"$myStartTimeSec
		echo $myStartTimeSec.$myStartTimeMsec",\c">>$DisplayTimeCsvPath
		myStartTimeSec=`python calTime.py "$myStartTimeSec"`
		myStartTimeSec=`echo $myStartTimeSec | cut -d '.' -f 1`
		# echo "$myStartTimeSec*1000+$myStartTimeMsec" | bc

		myEndTime=`cat $DisplayTimeLog | grep ${bbtreeActivityList[$i]} | grep "Displayed" | tail -n1 | cut -d " " -f1,2`
		myEndTimeSec=`echo $myEndTime | cut -d "." -f 1`
		myEndTimeMsec=`echo $myEndTime | cut -d "." -f 2`
		myYear=`date +%Y`
		myEndTimeSec=$myYear"-"$myEndTimeSec
		echo $myEndTimeSec.$myEndTimeMsec",\c">>$DisplayTimeCsvPath
		myEndTimeSec=`python calTime.py "$myEndTimeSec"`
		myEndTimeSec=`echo $myEndTimeSec | cut -d "." -f 1`
		# echo "$myEndTimeSec*1000+$myEndTimeMsec" | bc

		echo "$myEndTimeSec*1000+$myEndTimeMsec-$myStartTimeSec*1000-$myStartTimeMsec" | bc>>$DisplayTimeCsvPath
	fi
done

function getMyDisplayTime(){
	csvFile=$1

	appName=`cat $csvFile | head -n 1 | cut -d "," -f 2`
	appVersion=`cat $csvFile | head -n 1 | cut -d "," -f 3`

	ActivityName=""
	echo "{name: '"$appName$appVersion"',data: [""\c" >>$DisplayTimeDataTempPath

	while read line
	do
		temp=`echo $line | cut -d "," -f 1`
		if [[ $temp =~ [0-9] ]]; then
			ActivityNameTemp=`echo $line | awk -F, '{print $2}'`
			ActivityDisplayTime=`echo $line | awk -F, '{print $6}'`
			if [[ $2 = "yes" ]]; then
				echo "'"$ActivityNameTemp"',\c" >>$DisplayTimeActivityTempPath
			fi
			echo $ActivityDisplayTime",\c" >>$DisplayTimeDataTempPath
		fi
	done < $csvFile
	echo "]},\c">>$DisplayTimeDataTempPath
	# myActivityDisplayTIme="{name: '"$appName$appVersion"',data: ["$ActivityDisplayTime"]},"
	# echo $myActivityDisplayTIme >>$DisplayTimeDataTempPath
}

# function getMyDisplayTimeActivity(){
# 	csvFile=$1
# 	# echo $1
# 	appName=`cat $csvFile | head -n 1 | cut -d "," -f 2`
# 	appVersion=`cat $csvFile | head -n 1 | cut -d "," -f 3`

# 	# ActivityName=""
# 	# echo "'"$appName$appVersion"'" >>$DisplayTimeActivityTempPath

# 	while read line
# 	do
# 		temp=`echo $line | cut -d "," -f 1`
# 		if [[ $temp =~ [0-9] ]]; then
# 			ActivityNameTemp=`echo $line | awk -F, '{print $2}'`
# 			ActivityDisplayTime=`echo $line | awk -F, '{print $6}'`
# 			# ActivityName=$ActivityName"'"$ActivityNameTemp"',"
# 			echo "'"$ActivityNameTemp"',\c" >>$DisplayTimeActivityTempPath
# 		fi
# 	done < $csvFile
# 	# echo "]},\c">>$DisplayTimeActivityTempPath
# 	# myActivityDisplayTIme="{name: '"$appName$appVersion"',data: ["$ActivityDisplayTime"]},"
# 	# echo $myActivityDisplayTIme >>$DisplayTimeDataTempPath
# }

# getMyDisplayTime $csvDirPath/"DisplayedTime_com.yaya.mmbang3.12.3.csv"
flag=0
ls $csvDirPath | while read line
do
	if [[ $line =~ "DisplayedTime" ]]; then
		# echo $csvDirPath/$line
		if [[ $flag = 0 ]]; then
			getMyDisplayTime $csvDirPath/$line yes
			flag=1
		else
			getMyDisplayTime $csvDirPath/$line no
		fi
	fi
done

cat -n $DisplayTimeHtmlDemoPath | while read line
do
	l=`echo $line | awk '{print $1}'`
	if [[ $l = 25 ]]; then
		cat $DisplayTimeActivityTempPath >> $DisplayTimeHtmlPath
	elif [[ $l = 49 ]]; then
		cat $DisplayTimeDataTempPath >> $DisplayTimeHtmlPath
	else
		echo `cat $DisplayTimeHtmlDemoPath | head -n $l | tail -n 1` >> $DisplayTimeHtmlPath
	fi
done


if [[ -f $DisplayTimeDataTempPath ]]; then
	rm $DisplayTimeDataTempPath
fi

if [[ -f $DisplayTimeActivityTempPath ]]; then
	rm $DisplayTimeActivityTempPath
fi





# cat $DisplayTimeLog | grep -n $packageName | grep "START" | cut -d ":" -f 1 |tr -d "\r" | while read line
# do
# 	echo "-------------START-----------------"

# 	echo $line
# 	start=`cat $DisplayTimeLog | head -n $line | tail -n 1`
# 	echo $start
# 	myStartTime=`echo $start | cut -d " " -f 1,2`
# 	myStartTimeSec=`echo $myStartTime | cut -d "." -f 1`
# 	myStartTimeMsec=`echo $myStartTime | cut -d "." -f 2`
# 	myYear=`date +%Y`
# 	myStartTimeSec=$myYear"-"$myStartTimeSec
# 	echo $myStartTimeSec
# 	myStartTimeSec=`python calTime.py "$myStartTimeSec"`
# 	myStartTimeSec=`echo $myStartTimeSec | cut -d '.' -f 1` 
# 	#echo "$myStartTimeSec*1000+$myStartTimeMsec" | bc

# 	# myFinalStartTime=$(($myStartTimeSec*1000+$myStartTimeMsec))
# 	# echo $myFinalStartTime

# 	for (( i = 1; i < 1000; i++ )); do
# 		myActivity=`echo $start | cut  -d " " -f $i`
# 		# #myActivity=`echo $start | awk 'BEGIN{i=1;}{if(i<NR){}}'`
# 		#echo $myActivity
# 		if [[ $myActivity =~ $packageName ]]; then
# 			# echo "SS:"$i
# 			myActivity=`echo $myActivity | cut -d "=" -f 2`
# 			break
# 		else
# 			continue
# 			# echo "DD:"$i
# 		fi
# 	done
	
# 	echo -n $myActivity"," >>$DisplayTimeCsvPath

# 	echo -n $myStartTime"," >>$DisplayTimeCsvPath

# 	end=`cat $DisplayTimeLog | sed -n $line,\\$p | grep $packageName | grep "Displayed" | grep $myActivity | head -n 1`
# 	echo $end
# 	myEndTime=`echo $end | cut -d " " -f 1,2 `
# 	echo $myEndTime
# 	echo -n $myEndTime"," >>$DisplayTimeCsvPath

# 	if [[ $myEndTime = "" ]]; then
# 		echo "" >>$DisplayTimeCsvPath
# 	else
# 		myEndTimeSec=`echo $myEndTime | cut -d "." -f 1`
# 		myEndTimeMsec=`echo $myEndTime | cut -d "." -f 2`
# 		myYear=`date +%Y`
# 		myEndTimeSec=$myYear"-"$myEndTimeSec
# 		myEndTimeSec=`python calTime.py "$myEndTimeSec"`
# 		myEndTimeSec=`echo $myEndTimeSec | cut -d "." -f 1`
# 		#echo "$myEndTimeSec*1000+$myEndTimeMsec" | bc

# 		echo "$myEndTimeSec*1000+$myEndTimeMsec-$myStartTimeSec*1000+$myStartTimeMsec" | bc >>$DisplayTimeCsvPath
# 	fi

# 	echo "(ms)"
# 	echo "-------------END-----------------"

# done


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

read choice

if [[ $choice = 1 ]]; then
	packageName="com.yaya.mmbang"
	DisplayTimeLog=$logPath/"MMBangDisplayTime.log"
elif [[ $choice = 2 ]]; then
	packageName="com.babytree.apps.pregnancy"
	DisplayTimeLog=$logPath/"BBtreeDisplayTime.log"
fi

echo "请输入apk的版本号"
read versionName

DisplayTimeCsvPath=$csvDirPath/"DisplayedTime_"$packageName$versionName".csv"
DisplayTimeHtmlDemoPath=$htmlPath/"htmlDemo"/"DisplayTimeDemo.html"
DisplayTimeHtmlPath=$htmlPath/"htmlTemp"/"DisplayTime.html"

if [[ -f $DisplayTimeCsvPath ]]; then
	rm -rf $DisplayTimeCsvPath
fi

# gfxinfo_temp=$rootPath"/result/temp_gfxinfo.txt"
# gfxinfo=$rootPath"/result/gfxinfo.txt"
# packageName="com.yaya.mmbang"


# mmbangActivityDict={
# 	"启动页面":"SplashActivity",
# 	"主页面":"MainActivity",

# 	"登录页面":"ActivityLogin",
# 	# "短信登录页":"ActivityPhoneCodeLogin",
# 	# "找回密码":"ActivityFindPassword",

# 	# "视频播放页":"VideoPlayerActivity",
# 	# "我的帮":"MyMMBangActivity",

# 	"推荐关注":"RecommendFollowActivity",
# 	"他人信息页":"PersonalActivity",
# 	"消息":"BangMessageActivity",
# 	"发帖":"CreateTopicInputActivity",

# 	"帮页面":"BangItemListActivity",
# 	"帖子详情页":"TopicDetailListActivity",
# 	# "帮信息页面":"BangInfoActivity",
				
# 	"收藏":"BangItemListActivity",
# 	"我的话题":"BangItemListActivity",  	
# 	"关注":"FriendsActivity",				  	
# 	"粉丝":"FriendsActivity",				  	
# 	"设置页面":"SettingActivity"
# }


# bbtreeActivityDict = {
# 	"启动页面":"MainActivity",
# 	"主页面":"SailfishActivity",

# 	"登录页面":"LoginActivity",

# 	"宝宝树推荐":"RecommendActivity",
# 	"他人信息页":"CenterActivity",
# 	"消息":"MessageCenterActivity",
# 	"发帖":"TopicPostActivity",

# 	"帮页面":"NewTopicListActivity",
# 	"帖子详情页":"TopicDetailActivity",

# 	"收藏":"MyFavoritesActivity",
# 	"我的帖子":"PostTopicListActivity",
# 	"关注":"FollowerAndFunsActivity",
# 	"粉丝":"FollowerAndFunsActivity",
# 	"设置页面":"SettingActivity"
# }

# filename="/Users/jimmy_zhou/Desktop/android/myresult/DisplayTime.txt"



nameList=("启动页面" "主页面" "登录页面" "宝宝树推荐" "他人信息页" "消息" "发帖" "帮页面" "帖子详情页" "收藏" "我的帖子" "关注" "粉丝" "设置页面")

mmbangActivityList=("SplashActivity" "MainActivity" "ActivityLogin" "RecommendFollowActivity" "PersonalActivity" \
	"BangMessageActivity" "CreateTopicInputActivity" "BangItemListActivity" "TopicDetailListActivity" "BangItemListActivity" \
	"BangItemListActivity" "FriendsActivity" "FriendsActivity" "SettingActivity")
bbtreeActivityList=("MainActivity" "SailfishActivity" "LoginActivity" "RecommendActivity" "CenterActivity" "MessageCenterActivity" \
	"TopicPostActivity" "NewTopicListActivity" "TopicDetailActivity" "MyFavoritesActivity" "PostTopicListActivity" \
	"FollowerAndFunsActivity" "FollowerAndFunsActivity" "SettingActivity")
echo ,$packageName,$versionName>>$DisplayTimeCsvPath
echo ,"页面名称","Activity展示时间">>$DisplayTimeCsvPath
for (( i = 0; i < ${#nameList[@]}; i++ )); do
	# echo $i
	if [[ $packageName = "com.yaya.mmbang" ]]; then

		DisplayedTime=`cat $DisplayTimeLog | grep $packageName | grep "Displayed" | grep ${mmbangActivityList[$i]} | head -n1 | cut -d "+" -f2`
		DisplayedTime=${DisplayedTime%???}
	elif [[ $packageName = "com.babytree.apps.pregnancy" ]]; then

		DisplayedTime=`cat $DisplayTimeLog | grep $packageName | grep "Displayed" | grep ${bbtreeActivityList[$i]} | head -n1 | cut -d "+" -f2`
		DisplayedTime=${DisplayedTime%???}
	fi
	# echo $DisplayTimeLog
	# echo $bbtreeActivityList
	echo $(($i+1)),${nameList[$i]},$DisplayedTime >>$DisplayTimeCsvPath
	# echo ${mmbangActivityList[$i]}
done
# cat -n $DisplayTimeLog | grep $packageName | grep "Displayed" | cut -d "+" -f2

function getMyDisplayTime(){
	csvFile=$1

	appName=`cat $csvFile | head -n 1 | cut -d "," -f 2`
	appVersion=`cat $csvFile | head -n 1 | cut -d "," -f 3`

	ActivityName=""
	ActivityDisplayTime=""

	while read line
	do
		temp=`echo $line | cut -d "," -f 1`
		if [[ $temp =~ [0-9] ]]; then
			ActivityNameTemp=`echo $line | awk -F, '{print $2}'`
			ActivityDisplayTimeTemp=`echo $line | awk -F, '{print $3}'`
			ActivityName=$ActivityName"'"$ActivityNameTemp"',"
			ActivityDisplayTime=$ActivityDisplayTime","$ActivityDisplayTimeTemp
		fi
		ActivityDisplayTime=${ActivityDisplayTime##?}
		# export $coldDataString
	done < $csvFile

	myActivityDisplayTIme="{name: '"$appName$appVersion"',data: [0"$ActivityDisplayTime"]},"
	echo $myActivityDisplayTIme >>$csvDirPath/"a.txt"
}

getMyDisplayTime $csvDirPath/"DisplayedTime_com.yaya.mmbang3.12.3.csv"
# ls $csvDirPath | while read line
# do
# 	if [[ $line =~ "DisplayedTime" ]]; then
# 		# echo $line
# 		echo `getMyDisplayTime $csvDirPath/$line` 
# 		# >>$DisplayTimeHtmlPath
# 	fi
# done




# cat -n DisplayTimeCsvPath | 

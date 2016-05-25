#! /bin/bash

# 主目录
# rootPath=`dirname $(pwd)`
# apkPath=$rootPath/"apk"
# htmlPath=$rootPath/"html"
# resultPath=$rootPath/"result"
# shellPath=$rootPath/"shell"
# logPath=$rootPath/"log"
# tempDirPath=$rootPath/"temp"
# htmlDemoDirPath=$htmlPath/"htmlDemo"

# 结果文件
# monkeyLogFilePath=$logPath/"monkeyLog.log"
# logcatLogFilePath=$logPath/"logcat.log"
# performanceFilePath=$logPath/"performance.csv"
# gfxinfoFilePath=$logPath/"gfxinfo.csv"

# temp文件
# gfxinfo_temp=$tempDirPath/"gfxinfo_temp.txt"

# # 包名
# packageName="com.yaya.mmbang"
# # monkey操作间隔时间
# thinkTime=500
# # seed值
# seed=1
# # 执行的操作次数
# eventNumber=100

# # 设置采集数据间隔时间，单位:s
# sleepTime=1

echo "---开始执行monkeyTest.sh---"
echo "-----开始清除已有log文件-----"

# if [[ -e $monkeyLogFilePath ]]; then
# 	rm -rf $monkeyLogFilePath
# fi

# if [[ -e $logcatLogFilePath ]]; then
# 	rm -rf $logcatLogFilePath
# fi

# if [[ -e $performanceFilePath ]]; then
# 	rm -rf $performanceFilePath
# fi

echo "Time,Activity,PSS_Dalvik,PSS_Native,PSS_Total,CPU_cpuinfo,CPU_top,RX_bytes,TX_bytes,BatteryLevel" >>$performanceFilePath
echo "Time,Activity,Draw,Prepare,Process,Execute">>$gfxinfoFilePath
# myPID=`adb shell dumpsys meminfo $packageName | grep pid | awk '{print $5}'`
myUID=`adb shell dumpsys package $packageName | grep packageSetting | cut -d "/" -f2 | cut -d "}" -f1`
if [[ $myUID = "" ]]; then
	adb install $apkFilePath
	myUID=`adb shell dumpsys package $packageName | grep packageSetting | cut -d "/" -f2 | cut -d "}" -f1`
fi
RX_bytes_initial=`adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{rx_bytes+=$6}END{print rx_bytes}'`
TX_bytes_initial=`adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{tx_bytes+=$8}END{print tx_bytes}'`

if [[ $RX_bytes_initial = "" ]]; then
	RX_bytes_initial=0
fi

if [[ $TX_bytes_initial = "" ]]; then
	TX_bytes_initial=0
fi

# echo "myPID:"$myPID
# echo "myUID:"$myUID
# echo "RX_bytes_initial:"$RX_bytes_initial
# echo "TX_bytes_initial:"$TX_bytes_initial

function collectLogcat(){
	echo "-----开始收集logcat-----"
	adb shell logcat -c
	adb shell logcat -v time >>$logcatLogFilePath&
}

function collectPerformance(){
	CurrentTime=`date +'%Y-%m-%d %H:%M:%S'`

	CurrentActivity=`adb shell dumpsys activity | grep mFocusedActivity | tail -n 1 | cut -d "/" -f 2 |cut -d " " -f 1 | sed 's/}//g'`
	CurrentActivity=${CurrentActivity#?}
	PSS_Dalvik=`adb shell dumpsys meminfo $packageName | grep "Dalvik Heap" | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3`
	PSS_Native=`adb shell dumpsys meminfo $packageName | grep "Native Heap" | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3`
	PSS_Total=`adb shell dumpsys meminfo $packageName | grep TOTAL | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3`

	CPU_cpuinfo=`adb shell dumpsys cpuinfo | grep $packageName | grep -v pushservice | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " " -f 1`
	CPU_top=`adb shell top -n 1 -d 0 | grep $packageName | grep -v pushservice | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " " -f 3`
	# Jiffies=`adb shell cat /proc/4603/stat`
	# echo "---"$myPID"---"$myUID"---"
	RX_bytes_now=`adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{rx_bytes+=$6}END{print rx_bytes}'`
	TX_bytes_now=`adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{tx_bytes+=$8}END{print tx_bytes}'`

	RX_bytes=$(($RX_bytes_now - $RX_bytes_initial))
	TX_bytes=$(($TX_bytes_now - $TX_bytes_initial))

	BatteryLevel=`adb shell dumpsys battery | grep level | awk -F: '{print $2}' | tr -d " "`
	# echo $BatteryLevel
	if [[ $CPU_cpuinfo =~ ^\+ ]]; then
		CPU_cpuinfo=${CPU_cpuinfo#?}
	fi

	echo $CurrentTime,$CurrentActivity,$PSS_Dalvik,$PSS_Native,$PSS_Total,$CPU_cpuinfo,$CPU_top,$RX_bytes,$TX_bytes,$BatteryLevel >>$performanceFilePath
	# sleep 1
}

function collectGfxinfo(){
	CurrentTime=`date +'%Y-%m-%d %H:%M:%S'`
	adb shell dumpsys gfxinfo $packageName > $gfxinfo_temp

	cat $gfxinfo_temp | while read line
	do
		if [[ $line =~ ^[0-9].[0-9] ]] && [[ ! $line =~ [a-zA-Z] ]]; then
			#statements
			gfxinfo_details=`echo $line | sed s/[[:space:]]/,/g`
			# echo $gfxinfo_details
			echo $CurrentTime","$CurrentActivity","$gfxinfo_details >> $gfxinfoFilePath
		elif [[ $line =~ ^$packageName ]]; then
			#statements
			CurrentActivity=`echo $line | cut -d "/" -f2`
			# echo $CurrentActivity
		fi
	done

	# echo "---"
	# TotalViewRootImpl=`cat $gfxinfo_temp | grep "Total ViewRootImpl" | head -n 1|cut -d ":" -f2 | tr -d " "`
	# echo $TotalViewRootImpl
	# StartLine=`cat $gfxinfo_temp | grep -n "Profile data in ms:" | head -n 1 | cut -d ":" -f1`
	# echo $StartLine
	# EndLine=`cat $gfxinfo_temp | grep -n "View hierarchy:" | head -n 1 | cut -d ":" -f1`
	# echo $EndLine
	# # echo $((EndLine-StartLine))
	# echo "---"

	# if [[ $StartLine = "" ]]; then
	# 	StartLine=1
	# fi
	# if [[ $EndLine = "" ]]; then
	# 	EndLine=`cat $gfxinfo_temp | wc -l | tr -d " "`
	# 	echo $EndLine
	# fi

	# cat $gfxinfo_temp | head -$EndLine | tail -$(($EndLine-$StartLine)) | while read line
	# do
	# 	if [[ $line =~ $packageName ]]; then
	# 		CurrentActivity=`echo $line | cut -d "/" -f2`
	# 	fi

	# 	if [[ $line =~ ^[0-9] ]]; then
	# 		gfxinfo_details=`echo $line | sed s/[[:space:]]/,/g`
	# 		# echo $gfxinfo_details
	# 		echo $CurrentTime","$CurrentActivity","$gfxinfo_details >> $gfxinfoFilePath
	# 	fi
	# done

}


echo "-----开始执行monkey测试命令-----"

# monkey测试命令
# adb shell monkey -p $packageName --throttle $thinkTime --ignore-timeouts --ignore-crashes --ignore-security-exceptions \
# --monitor-native-crashes -v -v -v -s $seed $eventNumber >> $monkeyLogFilePath&

adb shell monkey -p $packageName --ignore-crashes --ignore-timeouts --ignore-security-exceptions --kill-process-after-error \
--throttle $thinkTime -v -v -v -s $seed $eventNumber >> $monkeyLogFilePath&
echo "adb shell monkey -p $packageName --ignore-crashes --ignore-timeouts --ignore-security-exceptions --kill-process-after-error \
--throttle $thinkTime -v -v -v -s $seed $eventNumber >> $monkeyLogFilePath&"
# 收集logcat信息
collectLogcat

sleep 1
# 循环判断采集数据的结束时间
echo "-----开始收集Performance信息-----"
while [[ true ]]; do
	result=`ps | grep "adb shell monkey" | grep -v grep`
	if [[ $result = "" ]]; then
		echo "ps | grep "adb shell monkey" | grep -v grep:"$result
		echo "-----检测到monkey执行完毕，跳出循环-----"
		break
	else
		echo "ps | grep "adb shell monkey" | grep -v grep:"$result
		echo "------monkey未结束，继续执行------"
		collectPerformance&
		collectGfxinfo&
		sleep $sleepTime
		# echo [$result]
	fi
done

echo "-----结束logcat进程-----"

PID=`ps | grep "adb shell logcat" | grep -v grep | awk -F " " '{print $1}'`
echo "PID2:"$PID
# ps
kill -9 $PID 1>/dev/null 2>&1
wait
# echo "---结束执行monkeyTest.sh---"

# sleep 3

# sh $shellPath/"PerformanceLog2HTML.sh"



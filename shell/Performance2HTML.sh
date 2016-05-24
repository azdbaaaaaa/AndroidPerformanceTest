#!/bin/bash

# rootPath=`dirname $(pwd)`
# apkPath=$rootPath/"apk"
# htmlPath=$rootPath/"html"
# resultPath=$rootPath/"result"
# shellPath=$rootPath/"shell"
# logPath=$rootPath/"log"
# tempDirPath=$rootPath/"temp"
# htmlDemoDirPath=$htmlPath/"htmlDemo"

# memoryHtmlFilePath=$htmlPath/"Memory.html"
# memoryHtmlDemoPath=$htmlDemoDirPath/"MemoryDemo.html"
# cpuHtmlFilePath=$htmlPath/"CPU.html"
# cpuHtmlDemoPath=$htmlDemoDirPath/"CPUDemo.html"

# performanceFilePath=$resultDirResultPath/"performance.csv"

echo "---开始执行Performance2HTML.sh---"

# if [[ -e $cpuHtmlFilePath ]]; then
# 	rm -rf $cpuHtmlFilePath
# fi

# if [[ -e $memoryHtmlFilePath ]]; then
# 	rm -rf $memoryHtmlFilePath
# fi


PSS_Dalvik_String=""
PSS_Native_String=""
PSS_Total_String=""
CurrentTimeString="categories: ["
i=1

while read line
do
	# 跳过第一行
	if [[ $i = 1 ]]; then
		i=0
		continue
	elif [[ $i = 2 ]]; then
		break
	fi

	# echo $line
	CurrentTime=`echo $line | awk -F, '{print $1}'`
	CurrentActivity=`echo $line | awk -F, '{print $2}'`
	PSS_Dalvik=`echo $line | awk -F, '{print $3}'`
	PSS_Native=`echo $line | awk -F, '{print $4}'`
	PSS_Total=`echo $line | awk -F, '{print $5}'`
	CPU_cpuinfo=`echo $line | awk -F, '{print $6}'`
	CPU_top=`echo $line | awk -F, '{print $7}'`
	RX_bytes=`echo $line | awk -F, '{print $8}'`
	TX_bytes=`echo $line | awk -F, '{print $9}'`
	BatteryLevel=`echo $line | awk -F, '{print $10}'`

	CPU_top=${CPU_top%\%}
	CPU_cpuinfo=${CPU_cpuinfo%\%}


	#处理数据为空时的情况
	if [[ $PSS_Dalvik = "" ]]; then
		PSS_Dalvik="0"
	fi

	if [[ $PSS_Native = "" ]]; then
		PSS_Native="0"
	fi

	if [[ $PSS_Total = "" ]]; then
		PSS_Total="0"
	fi

	if [[ $CPU_cpuinfo = "" ]]; then
		CPU_cpuinfo="0"
	fi

	if [[ $CPU_top = "" ]]; then
		CPU_top="0"
	fi
	# echo "CPU_cpuinfo:"$CPU_cpuinfo
	# echo "CPU_top:"$CPU_top

	PSS_Dalvik_String=$PSS_Dalvik_String",{y:"$PSS_Dalvik",activity:'"$CurrentActivity"'}"
	# echo $PSS_DalvikString
	PSS_Native_String=$PSS_Native_String",{y:"$PSS_Native",activity:'"$CurrentActivity"'}"
	PSS_Total_String=$PSS_Total_String",{y:"$PSS_Total",activity:'"$CurrentActivity"'}"

	CPU_cpuinfo_String=$CPU_cpuinfo_String",{y:"$CPU_cpuinfo",activity:'"$CurrentActivity"'}"
	CPU_top_String=$CPU_top_String",{y:"$CPU_top",activity:'"$CurrentActivity"'}"

	CurrentTimeString=$CurrentTimeString"'"$CurrentTime"',"
	# i=2
done < $performanceFilePath

PSS_Dalvik_String=${PSS_Dalvik_String#?}
PSS_Native_String=${PSS_Native_String#?}
PSS_Total_String=${PSS_Total_String#?}

CPU_cpuinfo_String=${CPU_cpuinfo_String#?}
CPU_top_String=${CPU_top_String#?}

CurrentTimeString=${CurrentTimeString%?}"]"

myPSS_Dalvik_String="{type:'area',name: 'PSS_Dalvik',data: ["$PSS_Dalvik_String"],color:'#70db93'},"
myPSS_Native_String="{type:'area',name: 'PSS_Native',data: ["$PSS_Native_String"],color:'#9932cd'},"
myPSS_Total_String="{type:'area',name: 'PSS_Total',data: ["$PSS_Total_String"],color:'#e47833'},"
# echo $myPSS_DalvikString

myCPU_cpuinfo_String="{name: 'CPU_cpuinfo',data: ["$CPU_cpuinfo_String"]},"
myCPU_top_String="{name: 'CPU_top',data: ["$CPU_top_String"]},"
# echo $CurrentTimeString
# echo $myCPU_cpuinfo_String

cat -n $memoryHtmlDemoPath | while read line
do
	l=`echo $line | awk '{print $1}'`
	if [[ $l = 75 ]]; then
		# echo "2222" >>$performanceHtmlFilePath
		echo $myPSS_Total_String$myPSS_Dalvik_String$myPSS_Native_String >> $memoryHtmlFilePath
	elif [[ $l = 28 ]]; then
		echo $CurrentTimeString >> $memoryHtmlFilePath
	else
		echo `cat $memoryHtmlDemoPath | head -n $l | tail -n 1` >> $memoryHtmlFilePath
	fi
done

cat -n $cpuHtmlDemoPath | while read line
do
	# echo $line
	l=`echo $line | awk '{print $1}'`
	# echo "["$l"]"
	if [[ $l = 57 ]]; then
		# echo "aaa"
		echo $myCPU_cpuinfo_String$myCPU_top_String >> $cpuHtmlFilePath
	elif [[ $l = 28 ]]; then
		# echo "bbb"
		echo $CurrentTimeString >> $cpuHtmlFilePath
	else
		# echo ""
		echo `cat $cpuHtmlDemoPath | head -n $l | tail -n 1` >> $cpuHtmlFilePath
	fi
done

echo "---结束执行Performance2HTML.sh---"


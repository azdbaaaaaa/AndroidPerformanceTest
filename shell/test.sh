PSS_Dalvik_String=""
PSS_Native_String=""
PSS_Total_String=""
CurrentTimeString="categories: ["
i=1
performanceFilePath="/Users/jimmy_zhou/Documents/workspace/AndroidPerformanceTest/result/com.yaya.mmbang_3.12.3/20160526141149/result/performance.csv"
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
	PSS_Dalvik=`echo $line | awk -F, '{print $3}'`
	PSS_Native=`echo $line | awk -F, '{print $4}'`
	PSS_Total=`echo $line | awk -F, '{print $5}'`
	CPU_cpuinfo=`echo $line | awk -F, '{print $6}'`
	CPU_top=`echo $line | awk -F, '{print $7}'`
	RX_bytes=`echo $line | awk -F, '{print $8}'`
	TX_bytes=`echo $line | awk -F, '{print $9}'`
	Folw_bytes=`echo $line | awk -F, '{print $10}'`
	CurrentActivity=`echo $line | awk -F, '{print $2}'`

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

	RX_bytes_String=$RX_bytes_String",{y:"$RX_bytes",activity:'"$CurrentActivity"'}"
	TX_bytes_String=$TX_bytes_String",{y:"$TX_bytes",activity:'"$CurrentActivity"'}"

	CurrentTimeString=$CurrentTimeString"'"$CurrentTime"',"
	# i=2
done < $performanceFilePath

CurrentTimeString=${CurrentTimeString%?}"]"
PSS_Dalvik_String=${PSS_Dalvik_String#?}


myPSS_Dalvik_String="{type:'area',name: 'PSS_Dalvik',data: ["$PSS_Dalvik_String"],color:'#70db93'},"
myPSS_Native_String="{type:'area',name: 'PSS_Native',data: ["${PSS_Native_String#?}"],color:'#9932cd'},"
myPSS_Total_String="{type:'area',name: 'PSS_Total',data: ["${PSS_Total_String#?}"],color:'#e47833'},"
# echo $myPSS_DalvikString

myCPU_cpuinfo_String="{name: 'CPU_cpuinfo',data: ["${CPU_cpuinfo_String#?}"]},"
myCPU_top_String="{name: 'CPU_top',data: ["${CPU_top_String#?}"]},"
# echo $CurrentTimeString
# echo $myCPU_cpuinfo_String
myRX_bytes_String="{name: 'RX_bytes',data: ["${RX_bytes_String#?}"]},"
myTX_bytes_String="{name: 'TX_bytes',data: ["${TX_bytes_String#?}"]},"


echo $myRX_bytes_String >/Users/jimmy_zhou/Documents/workspace/AndroidPerformanceTest/result/com.yaya.mmbang_3.12.3/20160526141149/result/a.txt

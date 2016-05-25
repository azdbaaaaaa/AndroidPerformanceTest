#! /bin/bash
export rootPath=`dirname $(pwd)`
export apkPath=$rootPath/"apk"
# echo "选择是否需要遍历apk文件夹下所有apk?(yes or no?)"
# read isNeedToRunOver
# if [[ $isNeedToRunOver = "yes" ]]; then
	ls $apkPath | while read line
	do
		# echo $line
		echo "-------start-----"
		# # 遍历apk
		export apkName=$line
		echo $apkName
		echo "选择需要测试的脚本:"
		echo "a.monkey测试（含性能）"
		echo "b.启动时间测试"
		echo "c.页面加载时间数据收集"
		echo "d.启动时间测试 + monkey测试（含性能）"
		# read a
		echo $a
		echo "-------end-----"
	done
# fi
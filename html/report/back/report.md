#Android性能专项测试报告
***
测试手机          |Android系统版本 |目标应用| 应用版本
-----------------|---------------|-------|------
小米 Note Pro     |5.0.2 |妈妈帮		| 3.12.3

##1.启动时间
1. **启动时间** 主要分为冷启动时间和热启动时间
2. 数据采集方式：

~~~
adb shell am start -W $packageName/$packageName.$Mainactivity
~~~
[WarmStartTime](file:///Users/jimmy_zhou/Desktop/android/html/WarmStartTime.html)

![WarmStartTime Screenshot](/Users/jimmy_zhou/Desktop/android/html/report/WarmStartTime.png)

[ColdStartTime](file:///Users/jimmy_zhou/Desktop/android/html/ColdStartTime.html)

![ColdStartTime Screenshot](/Users/jimmy_zhou/Desktop/android/html/report/ColdStartTime.png)

##2.主要页面加载时间
1. **主要页面加载时间** 统计了应用中部分页面activity的Displayed时间(不包含接口的响应时间)
2. 数据采集方式：

~~~
$mmbangActivityList=("MainActivity" "SplashActivity" ...)
cat $DisplayTimeLog | grep $packageName | grep "Displayed" | grep ${mmbangActivityList[$i]} | head -n1 | cut -d "+" -f2
~~~

[DisplayTime](file:///Users/jimmy_zhou/Desktop/android/html/ColdStartTime.html)

![DisplayTime Screenshot](/Users/jimmy_zhou/Desktop/android/html/report/ColdStartTime.png)

##3.资源消耗
主要包含：CPU、Memory、耗电量、耗流量、流畅度

采集数据场景：在跑monkey测试的同时，进行数据采集，后续会进行在appium页面遍历的场景下进行数据采集
###CPU
1. **CPU** 主要统计了在跑monkey的同时，cpu占用率的曲线变化
2. 啊啊啊
3. 数据采集方式：同时采集了top(进程的cpu jiffies与总的cpu jiffies比值)和cpuinfo(时间占比)两组cpu数据

~~~
adb shell dumpsys cpuinfo | grep $packageName | grep -v pushservice | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " " -f 1
~~~

~~~
adb shell top -n 1 -d 0 | grep $packageName | grep -v pushservice | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " " -f 3
~~~
[CPU](file:///Users/jimmy_zhou/Desktop/android/html/CPU.html)

![CPU Screenshot](/Users/jimmy_zhou/Desktop/android/html/report/CPU.png)

###Memory
1. **Memory** 主要统计了在跑monkey的同时，PSS占用率的曲线变化(未root下无法采集到USS)
2. 啊啊啊
3. 数据采集方式：同时采集了PSS中（Dalvik Heap、Native Heap、TOTAL）

~~~
adb shell dumpsys meminfo $packageName | grep Dalvik | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3

adb shell dumpsys meminfo $packageName | grep Native | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3

adb shell dumpsys meminfo $packageName | grep TOTAL | head -n 1 | sed -E 's/[[:space:]]+/ /g' | sed 's/^ //g' | cut -d " "  -f 3
~~~

[Memory](file:///Users/jimmy_zhou/Desktop/android/html/Memory.html)

![Memory Screenshot](/Users/jimmy_zhou/Desktop/android/html/report/Memory.png)

###耗流量
1. 可以通过tcpdump抓包，再通过wireshake直接读取包信息来获得流量
2. 数据采集方式（程序运行时先记录当前流量值，作为初始流量值，然后再继续程序运行中流量的差值）：

~~~
adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{rx_bytes+=$6}END{print rx_bytes}'

adb shell cat /proc/net/xt_qtaguid/stats | grep $myUID | awk '{tx_bytes+=$8}END{print tx_bytes}'
~~~

###耗电量
1. 功耗的计算=CPU消耗+Wakelock消耗+数据传输消耗+GPS消耗+Wi-Fi连接消耗，由于这种方法计算比较复杂，所以暂时采取下面这种方式。
2. 数据采集方式：

~~~
adb shell dumpsys battery | grep level | awk -F: '{print $2}' | tr -d " "
~~~

###流畅度
1. 啊啊
2. 数据采集方式：

~~~
adb shell dumpsys gfxinfo $packageName
~~~

##4.页面重绘
**验收标准**：

* 不允许出现黑色像素
* 不允许存在4x过度绘制
* 不允许存在面积超过屏幕1/4区域的3x过度绘制（淡红色区域）

ps：只有android4.2及以上的版本才具备此功能

##5.内存泄漏&内存溢出
TBD

##6.monkey压力测试
**测试策略1**：不同的登录状态：已登录、未登录

**测试策略2**：不同的网络状态：无网络、2g网络、3g网络、4g网络、WiFi网络

**测试策略3**：不同的内存状态：低内存、中内存、高内存

**测试策略4**：不同的CPU状态：低CPU、中CPU、高CPU

**测试策略5**：不同的电池状态：低电量、中电量、高电量

**测试策略6**：不同的monkey运行参数：seed值、throttle时间、各种事件百分比

...

##7.安全检查
####反编译
####代码混淆
####敏感数据：传输加密与校验
####敏感数据：本地缓存及本地数据库检查
####敏感数据：日志数据检查



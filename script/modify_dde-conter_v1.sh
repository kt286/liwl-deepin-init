#!/bin/bash
#本脚本通过gsetting配置控制中心和任务栏

###控制中心

#字体设置
gsettings set com.deepin.dde.appearance font-standard 'Microsoft YaHei UI'
#圆角设置。8表示中圆角。
gsettings set com.deepin.xsettings dtk-window-radius 8
#使用电池，笔记本盒盖，关闭屏幕
gsettings set com.deepin.dde.power battery-lid-closed-action 'turnOffScreen'
#使用电池，自动锁屏，从不
gsettings set com.deepin.dde.power battery-lock-delay 0 
#使用电池，关闭显示器,从不
gsettings set com.deepin.dde.power battery-screen-black-delay 0
#使用电池，进入待机，从不
gsettings set com.deepin.dde.power battery-sleep-delay 0
#连接电源，笔记本盒盖，关闭屏幕
gsettings set com.deepin.dde.power line-power-lid-closed-action 'turnOffScreen'
#连接电源，自动锁屏,从不
gsettings set com.deepin.dde.power line-power-lock-delay 0
#连接电源，关闭显示器，从不
gsettings set com.deepin.dde.power line-power-screen-black-delay 0
#连接电影，进入待机模式，从不
gsettings set com.deepin.dde.power line-power-sleep-delay 0 

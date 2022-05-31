#!/bin/bash
# 本脚本通过busctl命令管理D-Bus，来实现部分功能。通过sudo apt instlal d-feet工具，可以具体查看D-Bus

busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '回收站' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '系统监视器' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '电源' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '显示桌面' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '屏幕键盘' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '通知中心' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '多任务视图' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '全局搜索' false
busctl --user call com.deepin.dde.Dock /com/deepin/dde/Dock com.deepin.dde.Dock setPluginVisible sb '截图录屏' false

###任务栏
#任务栏设置为高效模式
gsettings set com.deepin.dde.dock display-mode 'efficient' 
#任务栏驻留应用。值通过/usr/share/applications/xxx.desktop的Name字段获取，格式'/S@APP_NAME'
gsettings set com.deepin.dde.dock docked-apps "['/S@microsoft-edge','/S@deepin-terminal']"
#设置时间格式(短时间格式:xxxx/xx/xx)
gsettings set com.deepin.dde.datetime short-date-format 3
#取消托盘隐藏
gsettings set com.deepin.dde.dock plugin-settings '{"datetime":{"Use24HourFormat":true,"pos_datetime_1":1},"grand-search":{"disabled":true,"pos_grand-search_1":1},"multitasking":{"enable":false,"pos_multitasking_1":2},"network":{"holded_network-item-key":true,"pos_network-item-key_1":1},"notifications":{"enable":false,"pos_notifications_0":3},"onboard":{"enable":false,"pos_onboard_1":2},"show-desktop":{"enable":false,"pos_show-desktop_1":2},"shutdown":{"enable":false,"pos_shutdown_1":3},"sound":{"holded_sound-item-key":true,"pos_sound-item-key_1":2},"system-monitor":{"enable":false},"trash":{"enable":false,"pos_trash_1":5},"tray":{"fashion-mode-trays-sorted":true,"fashion-tray-expanded":true,"holded_sni:Fcitx":true,"holded_sni:Nutstore":false,"holded_window:onboard":false,"pos_sni:Fcitx_1":3}}'
busctl --user call com.deepin.dde.daemon.Dock /com/deepin/dde/daemon/Dock com.deepin.dde.daemon.Dock SetPluginSettings s "{\"datetime\":{\"Use24HourFormat\":true,\"pos_datetime_1\":1},\"grand-search\":{\"disabled\":true,\"pos_grand-search_1\":1},\"multitasking\":{\"enable\":false,\"pos_multitasking_1\":2},\"network\":{\"holded_network-item-key\":true,\"pos_network-item-key_1\":1},\"notifications\":{\"enable\":false,\"pos_notifications_0\":3},\"onboard\":{\"enable\":false,\"pos_onboard_1\":2},\"show-desktop\":{\"enable\":false,\"pos_show-desktop_1\":2},\"shutdown\":{\"enable\":false,\"pos_shutdown_1\":3},\"sound\":{\"holded_sound-item-key\":true,\"pos_sound-item-key_1\":2},\"system-monitor\":{\"enable\":false},\"trash\":{\"enable\":false,\"pos_trash_1\":5},\"tray\":{\"fashion-mode-trays-sorted\":true,\"fashion-tray-expanded\":true,\"holded_sni:Fcitx\":true,\"holded_sni:Nutstore\":false,\"holded_window:onboard\":false,\"pos_sni:Fcitx_1\":3}}"

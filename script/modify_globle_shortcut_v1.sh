#!/bin/bash

#删除全局
#设置super+1打开Edge浏览器
busctl --user call com.deepin.daemon.Keybinding /com/deepin/daemon/Keybinding com.deepin.daemon.Keybinding DeleteShortcutKeystroke sis "switch-to-workspace-1" 3 "<Super>1"
busctl --user call com.deepin.daemon.Keybinding /com/deepin/daemon/Keybinding com.deepin.daemon.Keybinding AddCustomShortcut sss "edge" "/opt/microsoft/msedge/msedge" "<Super>1"

#设置super+2打开deepin-terminal
busctl --user call com.deepin.daemon.Keybinding /com/deepin/daemon/Keybinding com.deepin.daemon.Keybinding DeleteShortcutKeystroke sis "switch-to-workspace-2" 3 "<Super>2"
busctl --user call com.deepin.daemon.Keybinding /com/deepin/daemon/Keybinding com.deepin.daemon.Keybinding ModifiedAccel sisb "terminal" 0 "<Super>2" true
gsettings set com.deepin.dde.keybinding.system terminal "['<Super>2']" #控制中心现实

#设置Alt+w打开微信wechat
busctl --user call com.deepin.daemon.Keybinding /com/deepin/daemon/Keybinding com.deepin.daemon.Keybinding AddCustomShortcut sss "wechat" "/opt/deepinwine/tools/sendkeys.sh w WeChat
" "<Alt>W"

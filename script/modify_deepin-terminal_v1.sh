#!/bin/bash
# 本脚本用于配置:自编译新增功能的deepin-terminal

CONFIG_DIR=$1
ME=$(whoami)

sudo cp ${CONFIG_DIR}/deepin-terminal/deepin-terminal   /usr/bin/deepin-terminal.liwl
sudo cp ${CONFIG_DIR}/deepin-terminal/deepin-terminal_zh_CN.qm /usr/share/deepin-terminal/translations/deepin-terminal_zh_CN.qm
sudo ln -fs /usr/bin/deepin-terminal.liwl /usr/bin/deepin-terminal
#拷贝终端配置文件
cp ${CONFIG_DIR}/deepin-terminal/config.conf /home/${ME}/.config/deepin/deepin-terminal/

#自定义命令
#cp ${CONFIG_DIR}/deepin-terminal/command-config.conf /home/${ME}/.config/deepin/deepin-terminal/
#远程管理
#cp ${CONFIG_DIR}/deepin-terminal/server-config.conf /home/${ME}/.config/deepin/deepin-terminal/

#主题配色。自编译终端修改了Dark和Light的配色参数
sudo cp ${CONFIG_DIR}/deepin-terminal/Dark.colorscheme /usr/share/terminalwidget5/color-schemes/
sudo cp ${CONFIG_DIR}/deepin-terminal/Light.colorscheme /usr/share/terminalwidget5/color-schemes/

#拷贝系统库
#sudo co ${CONFIG_DIR}/deepin-terminal/libterminalwidget5.so.0.14.1 /lib/x86_64-linux-gnu/

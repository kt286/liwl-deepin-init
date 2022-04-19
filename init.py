#!/usr/bin/env python3

import sys
import os
import subprocess

CONF_DIR = "conf"
DESKTOP_DIR = "desktop"
FONTS_DIR = "fonts"
PICTURE_DIR= "picture"
SCRIPT_DIR = "script"

action_list = [
        {'更新系统':"update_v1.sh"},
        {'卸载自带应用':"purge_deepin_apps_v1.sh y"},
        {'删除主题':"my_subsequent_command_v1.sh -c"},
        {"删除图片":"my_subsequent_command_v1.sh -d"},
        {'安装字体':"my_subsequent_command_v1.sh -a %s" % FONTS_DIR},
        {'安装Fcitc5':"install_modify_fcitx5_v1.sh %s/fcitx5 y" % CONF_DIR},
        {'安装常用应用':"install_from_deepin_store_v1.sh y %s %s %s" % (PICTURE_DIR,DESKTOP_DIR,CONF_DIR)},
        {'设置控制中心':"modify_dde-conter_v1.sh"},
        {'设置任务栏':"modify_dde-dock_v1.sh"},
        {'修改图片':"modify_picture_v1.sh %s y" % PICTURE_DIR},
        {'修改锁屏界面':"my_subsequent_command_v1.sh -b %s" % CONF_DIR},
        {'设置sudo无密码':"my_subsequent_command_v1.sh -g %s" % CONF_DIR},
        {'创建右键选项':"modify_right_click_v1.sh y"},
        {'安装自编译终端':"modify_deepin-terminal_v1.sh %s" % CONF_DIR},
        {'配置vimrc':"my_subsequent_command_v1.sh -e %s" % CONF_DIR},
        {'配置bashrc':"my_subsequent_command_v1.sh -f %s" % CONF_DIR},
        {'配置全局快捷键':"modify_globle_shortcut_v1.sh"},
        {'修改启动界面':"modify_grub_v1.sh"},
]

def execute_local_command(command):
    command_rtn = subprocess.run(command,shell=True,stderr=subprocess.PIPE,encoding="utf-8",timeout=900)
    if command != "sudo apt list >/dev/null":
        print("%s [成功]" % command) if command_rtn.returncode == 0 else print("%s [失败]" % command)

def run(auto=False):
    for act in action_list:
        for describe,script in act.items():
            print("是否执行操作:%s" % describe)
            if auto:
                answer="y"
            else:
                answer = str(input("是否执行:%s.(y/n)?" % describe))
            if answer == "y" and script != "":
                print("执行操作:%s" % describe)
                execute_local_command("/bin/bash %s/%s" %  (SCRIPT_DIR,script))
            else:
                print("不执行操作:%s" % describe)

if __name__ == "__main__":
    print("获取操作权限")
    execute_local_command("sudo apt list >/dev/null")
    if len(sys.argv) != 2:
        run()
    else:
        run(sys.argv[1])
    execute_local_command("sudo apt -y autoremove >/dev/null")
    execute_local_command("sudo reboot")

#!/bin/bash
# 卸载deepin自带应用

IFS=','
deepin_apps=(
    #行首使用'#'注释不需要卸载的应用即可
    "浏览器":"org.deepin.browser"
    "下载器":"org.deepin.downloader"
    "帮助手册":"deepin-manual dde-manual-content"
    "欢迎":"dde-introduction"
    "用户反馈":"deepin-feedback"
    "启动盘制作工具":"deepin-boot-maker"
    "磁盘管理器":"deepin-diskmanager"
    "设备管理器":"deepin-devicemanager"
    "字体管理器":"deepin-font-manager"
    "日志查看器":"deepin-log-viewer"
    "系统监视器":"deepin-system-monitor"
    "归档管理器":"deepin-compressor"
    "文档查看器":"deepin-reader"
    "语音记事本":"deepin-voice-note"
    "打印机管理":"dde-printer"
    "画图":"deepin-draw"
    "相册":"deepin-album"
    "音乐":"deepin-music"
    "邮箱":"deepin-mail"
    "影院":"deepin-movie"
    "日历":"dde-calendar"
    "相机":"deepin-camera"
    "计算器":"deepin-calculator"
    "屏保":"deepin-screensaver"
    "壁纸":"deepin-wallpapers"
    "快捷键预览":"deepin-shortcut-viewer"
    "全局检索":"dde-grand-search"
    "应用商店":"deepin-app-store"
    "扫描易":"simple-scan"
    "LibreOffice办公":"LibreOffice*"
    "连连看":"com.deepin.lianliankan"
    "五子棋":"com.deepin.gomoku"
    "社区论坛":"deepin-forum"
    "深度ID":"deepin-deepinid-client"
    "备份恢复":"deepin-recovery-plugin deepin-ab-recovery"
    "nano编辑器":"nano"
    #"截图录屏":"deepin-screen-recorder"
    #"看图":"deepin-image-viewer"
    #"软件管理器":"deepin-deb-installer"
    #"文本编辑器":"deepin-editor"
    #"终端":"deepin-terminal"
)
ask_for_app(){
    local answer=$1
    for app in ${deepin_apps[*]}
    do
        if [ "${answer}" == "y" ]
        then
            ANS="y"
        else
            echo -ne "是否卸载:${app%:*},(y/n)?"
            read ANS
        fi
        if [ "${ANS}" == "y" ] || [ "${ANS}" == "" ]
        then
            echo -ne "即将卸载:[${app%:*}].执行卸载命令:[sudo apt -y purge ${app#*:}]..."
            #卸载命令
            eval sudo apt -y purge ${app#*:} >/dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "[成功]"
            else
                echo "[失败]"
            fi
        else
           echo "不卸载:${app%:*}" 
        fi
    done
}
sudo apt >/dev/null #首先输入sudo密码
ask_for_app $1
#删除icon残留。不进行这一步，全屏启动器会保留卸载应用的icon
rm -rf /home/${USER}/.config/deepin/dde-launcher-app-*

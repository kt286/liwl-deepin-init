#!/bin/bash
# 本脚本用于一健更换壁纸，背景图片，用户图像

IFS=','
#获取当前用户
ME=$(whoami)
#保留的主题bloom
THEME="bloom"
BLOOM_PLACE="/usr/share/icons/${THEME}/places"
#放置图片的目录
PICTURE_DIR=$1

# 修改壁纸,修改壁纸的操作应该放在背景图后面
modify_desktop(){
    cp ${PICTURE_DIR}/desktop.jpg /home/${ME}/.config/deepin/dde-daemon/appearance/custom-wallpapers/
    scree=$(xrandr|egrep "connected primary"|awk '{print $1}') 
    echo ${scree}
    dbus-send \
    --dest=com.deepin.daemon.Appearance /com/deepin/daemon/Appearance  \
    --print-reply com.deepin.daemon.Appearance.SetMonitorBackground string:"${scree}" string:"file:///home/${ME}/.config/deepin/dde-daemon/appearance/custom-wallpapers/desktop.jpg"
}

# 修改背景图片
modify_background(){
    DIR=/var/cache/deepin/dde-daemon/image-effect/pixmix
    sudo cp ${PICTURE_DIR}/background.jpg /usr/share/wallpapers/deepin/desktop.jpg
    sudo cp ${PICTURE_DIR}/background.jpg /usr/share/backgrounds/default_background.jpg
    sudo ln -fs /usr/share/wallpapers/deepin/desktop.jpg /etc/alternatives/deepin-default-background
    sudo cp ${PICTURE_DIR}/background.jpg ${DIR}
    cd /var/cache/deepin/dde-daemon/image-effect/pixmix
    for img in $(ls ${DIR}|egrep -v background.jpg)
    do
	sudo cp ${DIR}/background.jpg ${DIR}/${img} && sudo chmod 600 ${DIR}/${img} && sudo chattr +i ${DIR}/${img}
    done
    cd -
}

# 修改用户图像
modify_account_icon(){
    sudo rm -rf /var/lib/AccountsService/icons/*.png
    sudo rm -rf /var/lib/AccountsService/icons/bigger/*.png
    sudo cp  ${PICTURE_DIR}/account.jpg  /var/lib/AccountsService/icons/1.png
}

# 修改启动器图标
modify_launcher(){
    for size in 128 16 24 256 32 48 512 64 96
    do
        sudo cp ${PICTURE_DIR}/deepin-launcher.svg ${BLOOM_PLACE}/${size}/deepin-launcher.svg
    done
}

action_list=(
    "更换启动器图标":"modify_launcher"
    "更换用户图像":"modify_account_icon"
    "更换桌面壁纸":"modify_desktop"
    "更换背景图片":"modify_background" #这个放在后面
)

ask_for_action(){
    local answer=$1
    for action in ${action_list[*]}
    do
        if [ "${answer}" == "y" ]
        then
            ANS="y"
        else
            echo -ne "是否安装:${action%:*},(y/n)?"
            read ANS
        fi
        if [ "${ANS}" == "y" ] || [ "${ANS}" == "" ]
        then
            echo -ne "即将:[${action%:*}].执行函数[${action#*:}]..."
            #eval ${action#*:} >/dev/null 2>&1
            eval ${action#*:}
            if [ $? -eq 0 ]
            then
                echo "[成功]"
            else
                echo "[失败]"
            fi
        else
           echo "不安装:${acction%:*}" 
        fi
    done
}
if [ $# -eq 0 ]
then
    echo "请指定图片放置目录"
    exit 0
fi
sudo apt >/dev/null #首先输入sudo密码
ask_for_action $2 $1

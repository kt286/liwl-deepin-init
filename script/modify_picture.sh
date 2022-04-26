#!/bin/bash
# ***************************************************************************

script_info(){
    echo "使用方法: bash $0 [ -a account ] [ -b background ] [ -d desktop ] [ -l launcher ] [ -y ]
        -a account  修改用户图像。account用于指定一张图片文件,如 liwl_account.png
        -b background 修改锁屏背景图。background用于指定一张图片文件，如liwl_background.png
        -d desktop  修改桌面壁纸。desktop用于指定一张图片，如liwl_desktop.png 
        -l launcher 修改启动器图标。launcher用于指定一个svg图片，如liwl_launcher.svg
        -y 默认执行修改，不交互
    "
    exit 0
}

picture_list=(
    "用户图像":"modify_account_icon"
    "桌面壁纸":"modify_desktop"
    "背景图片":"modify_background"
    "启动器图标":"modify_launcher"
)


#更换用户图像
function modify_account(){
    local account_icon=$1
    if [ $# -ne 1 ]
    then
        echo "未指定用户图像图片文件"
        exit 0
    fi
    echo "更换用户图像为:${account_icon}"
    #更换操作
    sudo rm -rf /var/lib/AccountsService/icons/*.png
    sudo rm -rf /var/lib/AccountsService/icons/bigger/*.png
    sudo cp ${account_icon} /var/lib/AccountsService/icons/1.png
}

#更换桌面壁纸
function modify_desktop(){
    local desktop_pic=$1
    if [ $# -ne 1 ]
    then
        echo "未指定桌面壁纸图片文件"
        exit 0
    fi
    echo "更换桌面壁纸中..."
    cp ${desktop_pic} /home/${USER}/.config/deepin/dde-daemon/appearance/custom-wallpapers/
    scree=$(xrandr|egrep "connected primary"|awk '{print $1}') 
    echo ${scree}
    dbus-send \
    --dest=com.deepin.daemon.Appearance /com/deepin/daemon/Appearance  \
    --print-reply com.deepin.daemon.Appearance.SetMonitorBackground \
    string:"${scree}" string:"file:///home/${USER}/.config/deepin/dde-daemon/appearance/custom-wallpapers/desktop.jpg"
}

#更换背景图片
function modify_background(){
    local background_pic=$1
    if [ $# -ne 1 ]
    then
        echo "未指定背景图片文件"
        exit 0
    fi
    #更改操作
    echo  "更换背景图片中..."
    sudo cp ${background_pic} /usr/share/wallpapers/deepin/desktop.jpg
    sudo cp ${background_pic} /usr/share/backgrounds/default_background.jpg
    sudo ln -fs /usr/share/wallpapers/deepin/desktop.jpg /etc/alternatives/deepin-default_background
    for img in $(ls /var/cache/deepin/dde-daemon/image-effect/pixmix/)
    do
        sudo cp ${background_pic} /var/cache/deepin/dde-daemon/image-effect/pixmix/${img}
        sudo chmod 600 /var/cache/deepin/dde-daemon/image-effect/pixmix/${img}
    done
}

#更换启动器图标
function modify_launcher(){
    local launcher_svg=$1
    if [ $# -ne 1 ]
    then
        echo "未指定启动器svg文件"
        exit 0
    fi
    #更换操作
    for size in 16 24 32 48 96 128 256 512
    do
        sudo cp ${launcher_svg} ${BLOOM_PLACE}/${size}/deepin-launcher.svg
    done
}

#更改用户图像
function execute_modify(){
    #根据参数选择是否交互
    local info=$1
    local func=$2
    local pic=$3
    local default=$4
    if [ "${default}" == "y"  ]
    then
        auto="true"
    else
        echo -ne "是否更换:${info},(输入y/n)?:"
        read auto
        if [ "${auto}" == "y" ] || [ "${auto}" == "" ]
        then
            auto="true"
        else
            auto="fasle"
        fi
    fi
    #根据交互结果执行
    if [ "${auto}" == "true" ]
    then
        echo "选择更换[${info}].开始执行更换函数:[${func}]"
        eval ${func} ${pic}
        if [ $? -eq 0 ]
        then
            echo "更换成功"
        else
            echo "更换失败"
        fi
    else    
        echo "选择不更换[${info}]。跳过"
    fi
}

#脚本主逻辑
function main(){ 
    while getopts "a:b:d:l:y" OPT
    do
        #判断选项中是否有-y选项
        for o in $*
        do
            rtn=$(echo ${o}|egrep "y"|wc -l)
            if [ "${rtn}" -eq 1 ]
            then
                ANSWER="y"
            else
                ANSWER="n"
            fi
        done

        #根据不同的选择做不同的操作。
        case ${OPT} in
            a)
                execute_modify "用户图像" modify_account ${OPTARG} ${ANSWER}
                ;;
            b)
                execute_modify "背景图片" modify_background ${OPTARG} ${ANSWER}
                ;;
            d)
                execute_modify "桌面图片" modify_desktop ${OPTARG} ${ANSWER}
                ;;
            l)
                execute_modify "启动器图标" modify_launcher ${OPTARG} ${ANSWER}
                ;;
            \?)
                script_info
                exit 0
                ;;
        esac
    done
}

#-----------------
if [ $# -eq 0 ]
then
    script_info
else
    main $*
fi

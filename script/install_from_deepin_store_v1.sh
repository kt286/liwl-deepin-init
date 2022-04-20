#!/bin/bash
# 在app_list里面

IFS=","
ME=$(whoami)

WIZNOTE_VERSION="0.1.73"
PICTURE_DIR=$2
DESKTOP_DIR=$3
CONFIG_DIR=$4

install_wechat(){
    sudo apt -y install com.qq.weixin.deepin
    sudo ln -fs /opt/apps/com.qq.weixin.deepin/entries/applications/com.qq.weixin.deepin.desktop   /usr/share/applications/com.qq.weixin.deepin.desktop
}

install_wps(){
    sudo apt -y install cn.wps.wps-office
    rm -rf /home/${ME}/.Templates/*
}

install_neteasy_cloud_music(){
    sudo apt -y install com.163.music
    sudo ln -fs /opt/apps/com.163.music/entries/applications/com.163.music.desktop      /usr/share/applications/com.163.music.desktop
    #这里需要添加对高分屏幕的判断，如果是高分屏幕，根据系统缩放比，为网易云音乐创建缩放比的desktop
    scale=$(gsettings get com.deepin.xsettings scale-factor)
    if [ "${scale}" != "1.0" ]
    then
        sudo sed -i '/Exec/d' /usr/share/applications/com.163.music.desktop 
        sudo sh -c "echo 'Exec= env QT_SCALE_FACTOR=${scale} /opt/apps/com.163.music/files/bin/netease-cloud-music %U' >> /usr/share/applications/com.163.music.desktop"
    fi
}

install_kvm(){
    sudo apt -y install qemu-kvm virt-manager
}

install_docker(){
    sudo apt -y install docker-ce
}

install_node(){
    sudo apt -y install nodejs npm
}

install_typora(){
    sudo apt -y install io.typora
    sudo ln -fs /opt/apps/io.typora/entries/applications/io.typora.desktop /usr/share/applications/io.typora.desktop
    #修复安装typora无icon和icon无图像的问题
    sudo cp ${PICTURE_DIR}/typora.png /usr/share/icons/hicolor/64x64/apps/
}

install_edge(){
    wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
    sudo apt -y update
    sudo apt -y install microsoft-edge-stable
}

install_vscode(){
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt -y update
    sudo apt -y install code
}

install_nutstore(){
    sudo apt -y install gir1.2-appindicator3-0.1 gir1.2-notify-0.7 libappindicator3-1 libdbusmenu-glib4 libdbusmenu-gtk3-4 libnautilus-extension1a
    curl -O https://pkg-cdn.jianguoyun.com/static/exe/installer/debian/nautilus_nutstore_amd64.deb
    if [ $? -eq 0 ]
    then
        sudo dpkg -i  nautilus_nutstore_amd64.deb
    fi
    rm -rf nautilus_nutstore_amd64.deb
    #cp ${CONFIG_DIR}/nutstore/nutstore-pydaemon.py /home/${ME}/.nutstore/dist/bin/ #用修改过得nutstore-pydaemon.py代替原来的，主要用在自定义同步目录后，home目录下会有NutStore Files目录的问题
}
install_wiznote(){
    curl -O https://get.wiz.cn/x/wiznote-desktop-${WIZNOTE_VERSION}-linux-x86_64.AppImage 
    if [ $? -eq 0 ]
    then
        sudo mkdir -p /opt/apps/cn.wiz
        sudo cp wiznote-desktop-${WIZNOTE_VERSION}-linux-x86_64.AppImage /opt/apps/cn.wiz/wiznote.AppImage
        sudo chmod +x /opt/apps/cn.wiz/wiznote.AppImage
        cp ${CONFIG_DIR}/wiznote/wiznote.png  /home/${ME}/.icons/
        sudo cp ${CONFIG_DIR}/wiznote/wiznote.desktop /usr/share/applications/
        rm -rf wiznote-desktop-${WIZNOTE_VERSION}-linux-x86_64.AppImage
    else
        exit -1
    fi
}
install_baidunetdisk(){
    sudo apt -y install com.baidu.baidunetdisk=4.3.0
    sudo ln -fs /opt/apps/com.baidu.baidunetdisk/entries/applications/com.baidu.baidunetdisk.desktop /usr/share/applications/com.baidu.baidunetdisk.desktop
    #删除文件管理器显示百度网盘入口
    sudo rm -rf /usr/share/dde-file-manager/extensions/appEntry/com.baidu.baidunetdiskv_uos.desktop
}

install_dtk(){
    sudo apt -y install qt5-default qtcreator cmake g++ git
    sudo apt -y install libdtkwidget-dev libdtkgui-dev libdtkcore-dev
    sudo apt -y install deepin-sdk qtcreator-template-dtk
}

app_list=(
    "Edge浏览器":"install_edge"
    #"微信":"install_wechat"
    #"WPS办公软件":"install_wps"
    #"网易云音乐":"install_neteasy_cloud_music"
    #"Typora编辑器":"install_typora"
    #"vscode编辑器":"install_vscode"
    #"为知笔记":"install_wiznote"
    #"坚果云":"install_nutstore"
    #"百度网盘":"install_baidunetdisk"
    #"kvm虚拟化环境":"install_kvm"
    #"docker容器环境":"install_docker"
    #"nodejs环境":"install_node"
    #"dtk开发环境":"install_dtk"
)

ask_for_app(){
    local answer=$1
    for app in ${app_list[*]}
    do
        if [ "${answer}" == "y" ]
        then
            ANS="y"
        else
            echo -ne "是否安装:${app%:*},(y/n)?"
            read ANS
        fi
        if [ "${ANS}" == "y" ] || [ "${ANS}" == "" ]
        then
            echo -ne "即将安装:[${app%:*}].执行安装函数[${app#*:}]..."
            eval ${app#*:} >/dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "[成功]"
            else
                echo "[失败]"
            fi
        else
           echo "不安装:${app%:*}" 
        fi
    done
}
sudo apt >/dev/null #首先输入sudo密码
ask_for_app $1 $2 $3 $4

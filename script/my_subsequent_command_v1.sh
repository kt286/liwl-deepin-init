#!/bin/bash
# 本脚本主要负责执行后续一些清理或者配置工具

DIR=$2

#需要保留的主题，在行前使用#注释
THEME=(
    "Papirus"
    "Vintage"
    "Adwaita"
    "bloom-dark"
    "bloom-classic*"
    "ubuntu-mono*"
    "gnome"
    "deepin"
)

#本脚本提供的动作。不需要的操作，在行前使用#注释
action_list=(
    "安装字体":"install_fonts 字体目录"
    "设置锁屏字体":"modify_lock_fonts"
    "配置sudo无密码":"modify_nopassword 配置目录"
    "删除不需要的主题":"rmdir_theme"
    "删除不需要的图片":"rm_picture"
    "配置vimrc":"modify_vimrc 配置目录"
    "配置bashrc":"modify_bashrc 配置目录"
    "配置文件管理器":"modify_dde-file-manager"
)

script_info(){
echo "
$0 -a #安装字体
$0 -b #锁屏字体
$0 -c #删除不需要主题
$0 -d #删除多余图片
$0 -e #配置vimrc
$0 -f #配置bashrc
$0 -g #配置无密码sudo
"
}

#安装字体
install_fonts(){
    if [ "${DIR}" != "fonts" ]
    then
        echo "指定的不是字体目录"
        exit 0
    fi
    cp -r ${DIR}/* /home/${USER}/.local/share/
    sudo cp  -r ${DIR}/* /usr/share/fonts/
}


#锁屏界面的字体设置
modify_lock_fonts(){
    sudo cp ${DIR}/xsettingsd.conf /etc/lightdm/deepin/
    dpi=$(gsettings get com.deepin.xsettings xft-dpi)
    sudo sh -c "echo Xft/DPI ${dpi} >> /etc/lightdm/deepin/xsettingsd.conf"
}

#删除不需要的主题
rmdir_theme(){
    for theme in ${THEME[*]}
    do
        sudo rm -rf /usr/share/icons/${theme}
    done
    #补充因为删除图片导致的卸载软件时顶兰通知icon丢失
    cp ${DIR}/deepin-appstore.svg /usr/share/icons/bloom/apps/48/deepin-appstore.svg
}


#删除多余图片
rm_picture(){
    sudo rm -rf /var/lib/AccountsService/icons/*.png
    sudo rm -rf /var/lib/AccountsService/icons/bigger/*.png
}

#配置vimrc
modify_vimrc(){
    cp ${DIR}/vim/vimrc /home/${USER}/.vimrc
}

#配置bashrc
modify_bashrc(){
    cp ${DIR}/bash/bashrc /home/${USER}/.bashrc
}

#配置当前用户无密码执行sudo
modify_nopassword(){
    sudo cp ${DIR}/sudo/sudoers /etc/sudoers
    sudo usermod -a -G sudo ${USER}
}


OPT=$1
case ${OPT} in
    -a)
        install_fonts $2
        ;;
    -b)
        modify_lock_fonts $2
        ;;
    -c)
        rmdir_theme
        ;;
    -d)
        rm_picture
        ;;
    -e)
        modify_vimrc $2
        ;;
    -f)
        modify_bashrc $2
        ;;
    -g)
        modify_nopassword $2
        ;;
    *)
        script_info
    ;;
esac

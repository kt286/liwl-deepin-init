#!/bin/bash
# **************************************************************************************************************
# 脚本功能说明:
#   本脚用来一键卸载deepin操作系统原配的fcitx输入法框架，安装仓库中的fcitx5,并且配置fcitx5，设置皮肤，加载词库等
# 存在的问题:
#   1.通过任务栏右键启动输入法配置时，样式丢失，变成gtk界面
#   2.控制中心-键盘和语言，没有"输入法"配置界面
#***************************************************************************************************************

IFS=','
#存放fcitx5相关文件的目录(包括:词库，配置，主题，图片等)
FCITX5_DIR=$1
FCITX5_ICON_DIR=${FCITX5_DIR}/icon
FCITX5_CONF_DIR=${FCITX5_DIR}/config
FCITX5_DICT_DIR=${FCITX5_DIR}/dictionaries
FCITX5_THEME_DIR=${FCITX5_DIR}/theme/meterial
FCITX5_MISC_DIR=${FCITX5_DIR}/misc

#卸载fcitx，安装fcitx5
install_fcitx5(){
    sudo apt -y purge fcitx*
    sudo apt -y install fcitx5 fcitx5-chinese-addons
}

#拷贝旧配置
cp_config(){
    if [ ! -d ${FCITX5_CONF_DIR} ]
    then
        echo "没有${FCITX5_CONF_DIR}目录"
        exit 0
    fi
    rm -rf /home/${USER}/.config/fcitx5/* && mkdir -p /home/${USER}/.config/fcitx5/
    cp -r ${FCITX5_CONF_DIR}/*  /home/${USER}/.config/fcitx5/
}

#更换主题
modify_theme(){
    if [ ! -d ${FCITX5_THEME_DIR} ]
    then
        echo "没有${FCITX5_THEME_DIR}目录"
        exit 0
    fi
    sudo cp -r ${FCITX5_THEME_DIR}     /usr/share/fcitx5/themes/
}

#配置标点符号
modify_symbol(){
    if [ ! -d ${FCITX5_MISC_DIR} ]
    then
        echo "没有${FCITX5_MISC_DIR}目录"
        exit 0
    fi
    sudo cp -r ${FCITX5_MISC_DIR}/punc.mb.zh_CN     /usr/share/fcitx5/punctuation/
}

#配置字典
modify_dict(){
    if [ ! -d ${FCITX5_DICT_DIR} ]
    then
        echo "没有${FCITX5_DICT_DIR}目录"
        exit 0
    fi
    mkdir -p /home/${USER}/.local/share/fcitx5/pinyin/dictionaries/
    cp -r ${FCITX5_DICT_DIR}/*         /home/${USER}/.local/share/fcitx5/pinyin/dictionaries/
}

#隐藏启动器fcitx5的相关图标
hiddle_icon(){
    sudo sed -i '$a\NoDisplay=true' /usr/share/applications/kbd-layout-viewer5.desktop
    sudo sed -i '$a\NoDisplay=true' /usr/share/applications/org.fcitx.Fcitx5.desktop
    #sudo sed -i '$a\NoDisplay=true' /usr/share/applications/fcitx5-configtool.desktop #不隐藏fcitx5配置界面
}

#配置任务栏输入法的图标
modify_dock_icon(){
    local choice=$1
    if [ "${choice}" == "win10" ]
    then
        sudo cp ${FCITX5_ICON_DIR}/english.svg /usr/share/icons/bloom/status/48/input-keyboard-symbolic.svg
        sudo cp ${FCITX5_ICON_DIR}/input-keyboard-symbolic.svg /usr/share/icons/bloom/status/48/input-keyboard.svg #解决键盘映射没有icon的问题
        sudo cp ${FCITX5_ICON_DIR}/chinese.svg /usr/share/icons/bloom/status/48/fcitx-pinyin.svg
    else
        sudo cp ${FCITX5_ICON_DIR}/input-keyboard-symbolic.svg /usr/share/icons/bloom/status/48/input-keyboard-symbolic.svg
        #sudo cp ${FCITX5_ICON_DIR}}/org.fcitx.Fcitx5.fcitx-pinyin.png /usr/share/icons/hicolor/48x48/apps/org.fcitx.Fcitx5.fcitx-pinyin.png #原来的图标,但是不是红色，是灰黑色
        sudo cp ${FCITX5_ICON_DIR}/pinyin.svg /usr/share/icons/bloom/status/48/fcitx-pinyin.svg
    fi
}

opt_list=(
	"配置标点":"modify_symbol"
	"更换主题":"modify_theme"
	"配置字典":"modify_dict"
	"隐藏启动器图标":"hiddle_icon"
	"配置任务栏图标win10方案":"modify_dock_icon win10"
)

ask_for_app(){
    local answer=$1
    for app in ${opt_list[*]}
    do
        if [ "${answer}" == "y" ]
        then
            ANS="y"
        else
            echo -ne "是否:${app%:*},(y/n)?"
            read ANS
        fi
        if [ "${ANS}" == "y" ] || [ "${ANS}" == "" ]
        then
            echo -ne "即将:[${app%:*}].执行命令:${app#*:}..."
            #执行函数
            eval ${app#*:}
            if [ $? -eq 0 ]
            then
                echo "[成功]"
            else
                echo "[失败]"
            fi
        else
           echo "不执行:${app%:*}" 
        fi
    done
}

echo -ne "安装fcitx5..."
install_fcitx5 >/dev/null 2>&1
if [ $? -eq 0 ] 
then
	echo "安装成功"
else
	echo "安装失败"
	exit 0
fi
if [ ! -d $1 ]
then
    echo "未指定配置文件目录"
    exit 0
fi
ask_for_app $2 $1
echo "同步配置..."
cp_config $1

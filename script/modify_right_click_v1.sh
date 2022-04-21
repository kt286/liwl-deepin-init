#!/bin/bash
# 本脚本主要用来创建右键扩增功能
# 1. 通过右键创建markdown文档
# 2. 通过右键.md文件，显示：发送到选项【博客园，为知笔记】

create_markdown(){
    sudo mkdir -p /usr/share/templates/.source
    sudo touch /usr/share/templates/.source/markdown-template.md
    sudo sh -c '
    echo """[Desktop Entry]
    Name=Markdown Doc
    Name[zh_CN]=Markdown文档
    Comment=Enter MD filename:
    Comment[zh_CN]=请输入Markdown文档名称：
    Type=Link
    URL=.source/markdown-template.md
    """ > /usr/share/templates/markdown-template.desktop
    '
    #消除desktop文件行首空格
    sudo sh -c "sed -ri 's/^\s*//g' /usr/share/templates/markdown-template.desktop"
}

send_to_cnblogs(){
    if [ ! -f /usr/share/deepin/dde-file-manager/oem-menuextensions/deepin_share_markdown_to.desktop ]
    then
        sudo touch /usr/share/deepin/dde-file-manager/oem-menuextensions/deepin_share_markdown_to.desktop
    fi
    sudo sh -c '
    echo """
    [Desktop Entry]
    Type=Application
    Name=发布文档到
    Actions=SendTocnblogs;SendTowiznote
    X-DFM-MenuTypes=SingleFile
    MimeType=text/markdown

    [Desktop Action SendTocnblogs]
    Name=博客园
    Exec=python3 /home/liwl/.liwl/deepin/dde-file-manager/cnblogs.com/publish.py --file %U
    Icon=send-to

    [Desktop Action SendTowiznote]
    Name=为知笔记
    Exec=nodejs /home/liwl/.liwl/deepin/dde-file-manager/wiz.cn/publish.js --file %U
    Icon=send-to
    """ > /usr/share/deepin/dde-file-manager/oem-menuextensions/deepin_share_markdown_to.desktop
    '
    sudo sh -c "sed -ri 's/^\s*//g' /usr/share/deepin/dde-file-manager/oem-menuextensions/deepin_share_markdown_to.desktop"
}

send_to_wiznote(){
    echo ""    
}

action_list=(
    "右键新建markdown":"create_markdown"
    #"右键发送到博客园":"send_to_cnblogs"
    #"右键发送到为知笔记":"send_to_wiznote"
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
            echo -ne "即将创建:[${action%:*}].执行创建函数[${action#*:}]..."
            eval ${action#*:} >/dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "[成功]"
            else
                echo "[失败]"
            fi
        else
           echo "不创建:${action%:*}" 
        fi
    done
}
sudo apt >/dev/null #首先输入sudo密码
ask_for_action $1

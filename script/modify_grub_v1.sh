#!/bin/bash
# 本脚本用来修改引导界面

#取消延时
sudo sed -i 's/GRUB_TIMEOUT=1/GRUB_TIMEOUT=0/g' /etc/default/grub
#取消主题
#sudo sed -i 's/GRUB_THEME/\#GRUB_THEME/g' /etc/default/grub #注释掉
sudo sed -i '/GRUB_BACKGROUND/d' /etc/default/grub #删除
sudo sed -i '/GRUB_THEME/d' /etc/default/grub #删除

#更新
sudo update-grub

#!/bin/bash
# 本脚本用于配置:文件管理器

CONFIG_DIR=$1
ME=$(whoami)
cp ${CONFIG_DIR}/dde-file-manager /home/${ME}/.config/deepin/

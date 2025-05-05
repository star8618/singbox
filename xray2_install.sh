#!/bin/bash

# 检查并安装必要的工具
if ! command -v unzip &> /dev/null; then
    echo "正在安装 unzip..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y unzip
    elif command -v yum &> /dev/null; then
        sudo yum install -y unzip
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y unzip
    elif command -v brew &> /dev/null; then
        brew install unzip
    else
        echo "无法安装 unzip，请手动安装后再运行脚本"
        exit 1
    fi
fi

# 下载文件
wget -O xray8.zip "https://raw.githubusercontent.com/star8618/singbox/refs/heads/main/xray8.zip"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "下载失败，请检查URL或网络连接"
    exit 1
fi

# 提示用户输入密码
echo "请输入解压密码："
read password

# 解压到/opt目录
unzip -P "$password" xray8.zip -d /opt/

# 检查解压是否成功
if [ $? -ne 0 ]; then
    echo "❌ 解压失败，请检查密码是否正确"
    exit 1
fi

# 进入/opt/xray2目录
cd /opt/xray8 || exit

# 给xray_reality文件设置权限
sudo chmod 777 xray-manager



# 询问用户是否需要自动安装
    ./xray-manager

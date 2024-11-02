#!/bin/bash

# 下载文件
wget -O xray.zip "https://raw.githubusercontent.com/star8618/singbox/refs/heads/main/xray.zip"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "下载失败，请检查URL或网络连接"
    exit 1
fi

# 解压到/opt目录（需要输入密码）
unzip -P "你的密码" xray.zip -d /opt/

# 检查解压是否成功
if [ $? -ne 0 ]; then
    echo "解压失败，请检查密码是否正确"
    exit 1
fi

# 进入/opt/xray目录
cd /opt/xray

# 给xray_reality文件设置权限
sudo chmod 777 xray_reality

# 运行xray_reality
./xray_reality 
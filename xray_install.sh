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
wget -O xray.zip "https://raw.githubusercontent.com/star8618/singbox/refs/heads/main/xray.zip"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "下载失败，请检查URL或网络连接"
    exit 1
fi

# 提示用户输入密码
echo "请输入解压密码："
read password

# 解压到/opt目录
unzip -P "$password" xray.zip -d /opt/

# 检查解压是否成功
if [ $? -ne 0 ]; then
    echo "❌ 解压失败，请检查密码是否正确"
    exit 1
fi

# 进入/opt/xray目录
cd /opt/xray || exit

# 给xray_reality文件设置权限
sudo chmod 777 xray_reality

# 在运行程序前提示用户输入新的 bot token
echo -e "\n请输入新的 Telegram Bot Token："
read new_token

# 提示用户输入新的 chat ID
echo -e "\n请输入新的 Chat ID："
read new_chatid

# 检查 config.yaml 是否存在
if [ -f "config.yaml" ]; then
    # 备份原配置文件
    cp config.yaml config.yaml.bak
    
    # 使用 sed 替换 bot_token 和 chat_id 值，保持原有格式
    sed -i "s/bot_token: \".*\"/bot_token: \"$new_token\"/" config.yaml
    sed -i "s/chat_id: \".*\"/chat_id: \"$new_chatid\"/" config.yaml
    
    if [ $? -eq 0 ]; then
        echo -e "\n✅ Bot Token 已更新为: $new_token"
        echo "✅ Chat ID 已更新为: $new_chatid"
        echo "原配置文件已备份为 config.yaml.bak"
    else
        echo -e "\n❌ 配置更新失败"
        # 恢复备份
        mv config.yaml.bak config.yaml
        exit 1
    fi
else
    echo -e "\n❌ 未找到配置文件 config.yaml"
    exit 1
fi

echo -e "\n🚀 配置完成，正在启动程序...\n"

# 运行xray_reality
./xray_reality

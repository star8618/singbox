#!/bin/bash

# 定义颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查系统类型并安装依赖
echo -e "${YELLOW}检查并安装必要的依赖...${NC}"
if command -v apt-get &> /dev/null; then
    # Debian/Ubuntu 系统
    sudo apt-get update
    sudo apt-get install -y wget unzip
elif command -v yum &> /dev/null; then
    # CentOS/RHEL 系统
    sudo yum -y update
    sudo yum -y install wget unzip
elif command -v pacman &> /dev/null; then
    # Arch Linux 系统
    sudo pacman -Sy
    sudo pacman -S --noconfirm wget unzip
else
    echo -e "${RED}未能识别的系统包管理器，请手动安装 wget 和 unzip${NC}"
    exit 1
fi

# 验证依赖是否安装成功
for cmd in wget unzip; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}$cmd 安装失败，请手动安装后重试${NC}"
        exit 1
    fi
done

echo -e "${GREEN}依赖安装完成${NC}"

# 创建临时目录用于下载
echo "创建临时目录..."
sudo mkdir -p /tmp/singbox_temp

# 下载文件
echo "正在下载 sing-box..."
if ! sudo wget -O /tmp/singbox_temp/sing-box.zip https://raw.githubusercontent.com/star8618/singbox/refs/heads/main/sing-box.zip; then
    echo -e "${RED}下载失败！请检查网络连接后重试${NC}"
    sudo rm -rf /tmp/singbox_temp
    exit 1
fi

# 解压文件到/mnt目录
echo "正在解压文件..."
if ! sudo unzip -o /tmp/singbox_temp/sing-box.zip -d /mnt/; then
    echo -e "${RED}解压失败！${NC}"
    sudo rm -rf /tmp/singbox_temp
    exit 1
fi

# 清理临时文件
sudo rm -rf /tmp/singbox_temp

# 设置权限
sudo chmod +x /mnt/sing-box/sing-box_install

# 运行安装程序
echo "开始运行安装程序..."
cd /mnt/sing-box && sudo ./sing-box_install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}安装完成！${NC}"
else
    echo -e "${RED}安装过程中出现错误，请检查日志${NC}"
    exit 1
fi 
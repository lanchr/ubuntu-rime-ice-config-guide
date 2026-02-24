#!/bin/bash
#===============================================================================
# Ubuntu 24.04 + Wayland 完美中文输入法一键配置脚本
# 方案: Fcitx5 + Rime (中州韵) + 雾凇拼音词库 + Material 皮肤
# 
# 使用方法:
#   chmod +x setup-rime-ice.sh
#   ./setup-rime-ice.sh
#===============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Ubuntu 24.04 雾凇拼音一键配置脚本${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 检测是否为 Ubuntu
if [[ ! -f /etc/lsb-release ]]; then
    echo -e "${RED}错误: 此脚本仅支持 Ubuntu 系统${NC}"
    exit 1
fi

# 检查是否需要 sudo
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}提示: 此脚本需要管理员权限${NC}"
    echo -e "${YELLOW}请在下方输入您的 sudo 密码 (输入时无任何显示)${NC}"
    read -s -p "Password: " SUDO_PASS
    echo ""
fi

#-----------------------------------------------------------------------------
# 第一步: 安装必要的依赖包
#-----------------------------------------------------------------------------
echo -e "${GREEN}[1/5] 安装 Fcitx5 及其依赖...${NC}"

install_pkg() {
    echo "$SUDO_PASS" | sudo -S apt update -qq
    echo "$SUDO_PASS" | sudo -S apt install -y -qq \
        fcitx5 \
        fcitx5-rime \
        fcitx5-frontend-gtk3 \
        fcitx5-frontend-gtk4 \
        fcitx5-frontend-qt5 \
        fcitx5-frontend-qt6 \
        fcitx5-config-qt \
        fcitx5-material-color \
        git \
        curl
}

install_pkg >/dev/null 2>&1 || {
    echo -e "${RED}错误: 包安装失败，请检查网络连接或手动运行上述命令${NC}"
    exit 1
}

echo -e "${GREEN}    ✓ 依赖安装完成${NC}"

#-----------------------------------------------------------------------------
# 第二步: 切换系统输入法框架
#-----------------------------------------------------------------------------
echo -e "${GREEN}[2/5] 切换系统输入法框架为 Fcitx5...${NC}"

echo "$SUDO_PASS" | sudo -S im-config -n fcitx5
echo -e "${GREEN}    ✓ 系统框架切换完成${NC}"

#-----------------------------------------------------------------------------
# 第三步: 下载雾凇拼音词库
#-----------------------------------------------------------------------------
echo -e "${GREEN}[3/5] 下载雾凇拼音词库...${NC}"

mkdir -p ~/.local/share/fcitx5/rime/
rm -rf ~/rime-ice-temp
git clone --depth=1 https://github.com/iDvel/rime-ice.git ~/rime-ice-temp >/dev/null 2>&1
cp -r ~/rime-ice-temp/* ~/.local/share/fcitx5/rime/
rm -rf ~/rime-ice-temp

echo -e "${GREEN}    ✓ 词库部署完成${NC}"

#-----------------------------------------------------------------------------
# 第四步: 配置文件写入 (关键步骤 - 防覆盖)
#-----------------------------------------------------------------------------
echo -e "${GREEN}[4/5] 写入 Fcitx5 配置...${NC}"

# 4.1 杀掉可能存在的旧 fcitx5 进程
killall fcitx5 2>/dev/null || true
sleep 1

# 4.2 写入输入法列表配置
cat > ~/.config/fcitx5/profile <<'EOF'
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=us
# Default Input Method
DefaultIM=rime

[Groups/0/Items/0]
# Name
Name=keyboard-us
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=rime
# Layout
Layout=

[GroupOrder]
0=Default
EOF

# 4.3 写入皮肤配置
mkdir -p ~/.config/fcitx5/conf/
cat > ~/.config/fcitx5/conf/classicui.conf <<'EOF'
Theme=Material-Color-DeepOcean
Font="Sans 13"
EOF

echo -e "${GREEN}    ✓ 配置写入完成${NC}"

#-----------------------------------------------------------------------------
# 第五步: 重启 Fcitx5
#-----------------------------------------------------------------------------
echo -e "${GREEN}[5/5] 启动 Fcitx5 服务...${NC}"

nohup fcitx5 >/dev/null 2>&1 &
sleep 2

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  配置完成! 请执行以下操作:${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}  1. 注销当前用户并重新登录 (或重启电脑)${NC}"
echo -e "${YELLOW}  2. 打开任意文本输入框${NC}"
echo -e "${YELLOW}  3. 按 Ctrl+Space 切换到 Rime${NC}"
echo -e "${YELLOW}  4. 右键点击右上角键盘图标 → 选择「部署(Deploy)」${NC}"
echo -e "${YELLOW}  5. 按 F4 选择「雾凇拼音」方案${NC}"
echo ""
echo -e "${GREEN}  祝您使用愉快!${NC}"
echo ""

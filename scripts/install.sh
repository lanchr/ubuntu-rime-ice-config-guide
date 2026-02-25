#!/bin/bash
#===============================================================================
# Ubuntu 24.04 + Wayland 雾凇拼音一键安装脚本
# 远程执行版本 - 自动下载并运行完整安装脚本
# 
# 使用方法:
#   curl -fsSL https://raw.githubusercontent.com/lanchr/ubuntu-rime-ice-config-guide/main/scripts/install.sh | bash
#===============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO_URL="https://github.com/lanchr/ubuntu-rime-ice-config-guide"
RAW_URL="https://raw.githubusercontent.com/lanchr/ubuntu-rime-ice-config-guide/main"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Ubuntu 24.04 雾凇拼音一键安装器${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 检测是否为 Ubuntu
if [[ ! -f /etc/lsb-release ]]; then
    echo -e "${RED}错误: 此脚本仅支持 Ubuntu 系统${NC}"
    echo -e "${YELLOW}提示: 如需在其他 Linux 发行版上安装，请参考手动安装指南${NC}"
    echo -e "${BLUE}文档: ${REPO_URL}${NC}"
    exit 1
fi

# 检测 Ubuntu 版本
UBUNTU_VERSION=$(lsb_release -rs)
echo -e "${BLUE}检测到 Ubuntu 版本: ${UBUNTU_VERSION}${NC}"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
trap "rm -rf ${TEMP_DIR}" EXIT

echo -e "${GREEN}[1/3] 正在下载安装脚本...${NC}"

# 下载完整的安装脚本
if command -v curl &> /dev/null; then
    curl -fsSL "${RAW_URL}/scripts/setup-rime-ice.sh" -o "${TEMP_DIR}/setup-rime-ice.sh"
elif command -v wget &> /dev/null; then
    wget -q "${RAW_URL}/scripts/setup-rime-ice.sh" -O "${TEMP_DIR}/setup-rime-ice.sh"
else
    echo -e "${RED}错误: 需要 curl 或 wget 来下载安装脚本${NC}"
    echo -e "${YELLOW}请安装: sudo apt install curl${NC}"
    exit 1
fi

if [[ ! -f "${TEMP_DIR}/setup-rime-ice.sh" ]]; then
    echo -e "${RED}错误: 下载安装脚本失败${NC}"
    echo -e "${YELLOW}请检查网络连接，或手动访问: ${REPO_URL}${NC}"
    exit 1
fi

echo -e "${GREEN}    ✓ 下载完成${NC}"

# 赋予执行权限
chmod +x "${TEMP_DIR}/setup-rime-ice.sh"

echo -e "${GREEN}[2/3] 正在运行安装脚本...${NC}"
echo ""

# 执行安装脚本
"${TEMP_DIR}/setup-rime-ice.sh"

echo ""
echo -e "${GREEN}[3/3] 安装完成！${NC}"
echo ""
echo -e "${BLUE}📚 相关资源:${NC}"
echo -e "${BLUE}   - 项目主页: ${REPO_URL}${NC}"
echo -e "${BLUE}   - 详细文档: ${REPO_URL}/blob/main/docs/ubuntu-rime-ice-config-guide.md${NC}"
echo ""
echo -e "${GREEN}🎉 感谢您使用本安装脚本！${NC}"

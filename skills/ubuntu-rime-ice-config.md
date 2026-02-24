# Skill: Ubuntu 24.04 雾凇拼音一键配置

## 触发词
- "配置 Ubuntu 中文输入法"
- "安装 Fcitx5 Rime"
- "Ubuntu 中文输入"

## 功能描述
在 Ubuntu 24.04 (Wayland) 环境下，一键配置完美的中文输入法：Fcitx5 + Rime (中州韵) + 雾凇拼音词库 + Material 主题皮肤。

## 执行步骤

### 1. 环境检查
- 检查是否为 Ubuntu 系统
- 检查当前桌面环境 (Wayland/X11)

### 2. 安装依赖
自动安装以下包:
- fcitx5, fcitx5-rime
- fcitx5-frontend-gtk3/gtk4/qt5/qt6
- fcitx5-config-qt, fcitx5-material-color

### 3. 系统配置
- 执行 `im-config -n fcitx5` 切换输入法框架
- 写入 `~/.config/fcitx5/profile` (确保 Rime 在列表中)
- 写入 `~/.config/fcitx5/conf/classicui.conf` (应用 Material 皮肤)

### 4. 词库部署
- 从 GitHub 克隆 iDvel/rime-ice 词库
- 部署到 `~/.local/share/fcitx5/rime/`

### 5. 服务重启
- 杀掉旧 Fcitx5 进程
- 启动新的 Fcitx5 服务

## 使用说明
配置完成后，用户需要:
1. 注销并重新登录 (或重启电脑)
2. 按 `Ctrl+Space` 切换输入法
3. 右键点击键盘图标 → 「部署(Deploy)」
4. 按 `F4` 选择「雾凇拼音」

## 关联脚本
`../scripts/setup-rime-ice.sh`

## 注意事项
- 需要 sudo 权限安装系统包
- 首次部署词库需要等待 10-30 秒
- 某些应用需要重启才能识别新输入法

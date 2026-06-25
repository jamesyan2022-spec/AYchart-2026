#!/usr/bin/env bash
# 将 manifest.xml 旁加载到 Mac 版 Excel
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
WEF="$HOME/Library/Containers/com.microsoft.Excel/Data/Documents/wef"
mkdir -p "$WEF"
cp "$DIR/manifest.xml" "$WEF/manifest.xml"
echo "✓ 已复制 manifest.xml 到："
echo "  $WEF"
echo ""
echo "下一步：完全退出并重启 Excel（⌘Q），在「开始」选项卡找到 隆众 ChartAI > 智能图表，"
echo "或通过「插入 > 我的加载项 > 共享文件夹」打开。"

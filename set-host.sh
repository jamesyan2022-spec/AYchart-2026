#!/usr/bin/env bash
# 把 manifest.xml 的地址从 localhost 改成你的在线托管地址
# 用法: ./set-host.sh https://你的用户名.github.io/仓库名
set -e
BASE="${1%/}"
if [ -z "$BASE" ]; then
  echo "用法: ./set-host.sh https://你的用户名.github.io/仓库名"
  exit 1
fi
DIR="$(cd "$(dirname "$0")" && pwd)"
# macOS 的 sed 需要 -i '' 形式
sed -i '' "s#https://localhost:3000#$BASE#g" "$DIR/manifest.xml"
echo "✓ 已把 manifest.xml 地址改为：$BASE"
echo ""
echo "下一步："
echo "  1) 运行  ./sideload-mac.sh"
echo "  2) ⌘Q 完全退出并重开 Excel"
echo "  之后无需再开终端、无需 serve.sh。"

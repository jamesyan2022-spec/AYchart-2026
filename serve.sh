#!/usr/bin/env bash
# 启动本地 HTTPS 服务（Office 加载项必须走 HTTPS）
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "==> 检查依赖（首次会自动安装）"
npm list -g office-addin-dev-certs >/dev/null 2>&1 || npm install -g office-addin-dev-certs
npm list -g http-server >/dev/null 2>&1 || npm install -g http-server

echo "==> 生成并信任本地开发证书（首次会弹出钥匙串授权，请输入开机密码）"
npx office-addin-dev-certs install

CERT_DIR="$HOME/.office-addin-dev-certs"
echo ""
echo "==> 服务启动于 https://localhost:3000  （按 Ctrl+C 停止）"
echo "    任务窗格地址：https://localhost:3000/src/taskpane.html"
echo ""
http-server "$DIR" -S \
  -C "$CERT_DIR/localhost.crt" \
  -K "$CERT_DIR/localhost.key" \
  -p 3000 --cors -c-1

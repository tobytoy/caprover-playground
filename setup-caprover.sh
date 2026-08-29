#!/usr/bin/env bash

echo "🚀 開始整備 GitHub Codespaces 環境並啟動 CapRover..."

# 1. 強制清理舊有的 CapRover 容器與 Swarm 狀態
echo "🧹 清理舊有環境與 Swarm 狀態..."
docker rm -f caprover 2>/dev/null || true
docker swarm leave --force 2>/dev/null || true

# 2. 清理並重新建立資料目錄
echo "📁 重置 /captain 資料目錄..."
sudo rm -rf /captain
sudo mkdir -p /captain

# 3. 啟動 CapRover 容器（由 CapRover 自動初始化 Swarm）
echo "🐳 啟動 CapRover 容器..."
sudo docker run -d \
  --name caprover \
  --restart always \
  -e MAIN_NODE_IP_ADDRESS=127.0.0.1 \
  -e ACCEPTED_TERMS=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /captain:/captain \
  -p 80:80 \
  -p 443:443 \
  -p 3000:3000 \
  caprover/caprover

echo ""
echo "=================================================="
echo "🎉 CapRover 已在背景啟動！"
echo "=================================================="
echo "📌 後續操作步驟："
echo "1. 點擊 Codespaces 下方的 [Ports] 頁籤"
echo "2. 找到 Port 3000，右鍵改為 [Port Visibility: Public]"
echo "3. 點擊 Port 3000 旁邊的 🌐 地球圖示開啟網頁"
echo "🔑 預設管理員密碼：captain42"
echo "=================================================="
echo "正在自動追蹤 Log（看到 Captain UP AND RUNNING 代表就緒，按 Ctrl+C 可結束監看）："
echo ""

sleep 3
docker logs -f caprover

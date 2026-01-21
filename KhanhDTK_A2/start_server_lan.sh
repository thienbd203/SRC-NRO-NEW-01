#!/bin/bash

echo "==================================="
echo "    NRO SERVER - LAN MODE"
echo "==================================="
echo ""
echo "Server Information:"
echo "- IP Address: 192.168.5.13"
echo "- Port: 14445"
echo "- Login Server: localhost:3105"
echo ""
echo "Đang khởi động server..."
echo ""

# Start Login Server
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Login"
echo "[LOGIN] Starting Login Server on port 3105..."
java -jar target/ServerLogin-1.0-RELEASE-jar-with-dependencies.jar &
LOGIN_PID=$!

# Wait 2 seconds
sleep 2

# Start Game Server
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Server"
echo "[GAME] Starting Game Server on 192.168.5.13:14445..."
java -jar target/TeaMobi-1.0-RELEASE-jar-with-dependencies.jar &
GAME_PID=$!

echo ""
echo "==================================="
echo "     SERVER ĐÃ KHỞI ĐỘNG!"
echo "==================================="
echo ""
echo "Kết nối từ điện thoại:"
echo "1. Mở game client"
echo "2. Nhập IP: 192.168.5.13"
echo "3. Port: 14445"
echo ""
echo "Login Server: localhost:3105 (PID: $LOGIN_PID)"
echo "Game Server: 192.168.5.13:14445 (PID: $GAME_PID)"
echo ""
echo "Nhấn Ctrl+C để dừng server..."
echo ""

# Wait for Ctrl+C
trap "echo ''; echo 'Đang dừng server...'; kill $LOGIN_PID $GAME_PID 2>/dev/null; exit" INT
wait

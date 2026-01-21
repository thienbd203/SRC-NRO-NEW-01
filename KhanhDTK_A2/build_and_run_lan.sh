#!/bin/bash

echo "========================================"
echo "    BUILD & START NRO SERVER LAN"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored text
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check Java
if ! command -v java &> /dev/null; then
    print_error "Java chưa được cài đặt!"
    exit 1
fi

# Check Maven
if ! command -v mvn &> /dev/null; then
    print_error "Maven chưa được cài đặt!"
    echo "Vui lòng chạy: brew install maven"
    exit 1
fi

# Get IP Address
IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -1)

print_status "IP Address của bạn: $IP"
print_status "Port Game Server: 14445"
print_status "Port Login Server: 3105"
echo ""

# Build Login Server
print_status "Đang build Login Server..."
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Login"
if mvn clean package -DskipTests > /dev/null 2>&1; then
    print_status "✓ Build Login Server thành công!"
else
    print_error "✗ Build Login Server thất bại!"
    exit 1
fi

# Build Game Server
print_status "Đang build Game Server..."
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Server"
if mvn clean package -DskipTests > /dev/null 2>&1; then
    print_status "✓ Build Game Server thành công!"
else
    print_error "✗ Build Game Server thất bại!"
    exit 1
fi

# Update IP in server.properties
print_status "Cập nhật IP trong config..."
sed -i '' "s/server.sv1=KhanhDTK:.*/server.sv1=KhanhDTK:$IP:14445:0,0,0/" "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Server/resources/config/server.properties"

echo ""
echo "========================================"
echo "     KHỞI ĐỘNG SERVER"
echo "========================================"
echo ""

# Start Login Server
print_status "Khởi động Login Server (port 3105)..."
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Login"
java -jar target/ServerLogin-1.0-RELEASE-jar-with-dependencies.jar &
LOGIN_PID=$!

# Wait 2 seconds
sleep 2

# Start Game Server
print_status "Khởi động Game Server ($IP:14445)..."
cd "/Users/thienbd/Downloads/SRC NRO NEW 01/KhanhDTK_A2/Server"
java -jar target/TeaMobi-1.0-RELEASE-jar-with-dependencies.jar &
GAME_PID=$!

echo ""
echo "========================================"
echo "     SERVER ĐÃ CHẠY THÀNH CÔNG!"
echo "========================================"
echo ""
echo -e "${GREEN}THÔNG TIN KẾT NỐI:${NC}"
echo -e "• IP Server: ${YELLOW}$IP${NC}"
echo -e "• Port: ${YELLOW}14445${NC}"
echo -e "• Login Server: ${YELLOW}localhost:3105${NC}"
echo ""
echo -e "${GREEN}TÀI KHOẢN ADMIN:${NC}"
echo -e "• Username: ${YELLOW}admin1${NC}"
echo -e "• Password: ${YELLOW}1${NC}"
echo ""
echo -e "${GREEN}KẾT NỐI TỪ ĐIỆN THOẠI:${NC}"
echo "1. Đảm bảo điện thoại và Mac cùng WiFi"
echo "2. Mở game client"
echo "3. Nhập IP: $IP"
echo "4. Port: 14445"
echo ""
echo -e "${GREEN}TỶ LỆ SKH:${NC}"
echo "• Rơi SKH: 50% (1/2)"
echo "• Tỉ lệ kích hoạt: 0.1% (1/1000)"
echo ""
echo -e "${YELLOW}Nhấn Ctrl+C để dừng server...${NC}"
echo ""

# Trap Ctrl+C
trap "echo ''; print_status 'Đang dừng server...'; kill $LOGIN_PID $GAME_PID 2>/dev/null; exit" INT
wait

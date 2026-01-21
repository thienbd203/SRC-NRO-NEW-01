#!/bin/bash

# Script chạy NRO Server
echo "Đang khởi động NRO Server..."

# Kiểm tra Java
if ! command -v java &> /dev/null; then
    echo "Lỗi: Chưa cài Java!"
    exit 1
fi

# Kiểm tra MySQL
if ! pgrep -x "mysqld" > /dev/null; then
    echo "Cảnh báo: MySQL chưa chạy!"
    echo "Vui lòng khởi động MySQL trước."
fi

# Tạo classpath
CLASSPATH="lib/*:src/main/java:resources"

# Tạo thư mục output
mkdir -p target/classes

# Biên dịch tất cả
echo "Biên dịch source code..."
find src/main/java -name "*.java" > sources.txt
javac -cp "$CLASSPATH" -d target/classes @sources.txt

# Chạy server
echo "Khởi động server..."
java -Xms512m -Xmx2048m -cp "$CLASSPATH:target/classes" nro.server.ServerManager

echo "Server đã dừng!"

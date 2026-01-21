#!/bin/bash

# Script chạy NRO Server đơn giản
echo "Đang khởi động NRO Server..."

# Kiểm tra Java
if ! command -v java &> /dev/null; then
    echo "Lỗi: Chưa cài Java!"
    exit 1
fi

# Chạy server với JAR có sẵn (nếu có)
if [ -f "target/ConCac-1.0-RELEASE-jar-with-dependencies.jar" ]; then
    echo "Chạy server từ JAR..."
    java -Xms512m -Xmx2048m -jar target/ConCac-1.0-RELEASE-jar-with-dependencies.jar
else
    echo "Không tìm thấy JAR. Vui lòng build bằng Maven:"
    echo "1. Mở IntelliJ IDEA"
    echo "2. Install Lombok plugin"
    echo "3. Enable Annotation Processing"
    echo "4. Build với Maven: mvn clean package"
fi

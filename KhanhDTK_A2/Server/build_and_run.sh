#!/bin/bash

echo "Build với Maven Annotation Processor..."

# Clean
mvn clean

# Build với annotation processing
mvn compile -Dmaven.compiler.processors=org.projectlombok.lombok.LombokAnnotationProcessor

# Package
mvn package -DskipTests

# Chạy nếu thành công
if [ -f "target/ConCac-1.0-RELEASE-jar-with-dependencies.jar" ]; then
    echo "Build thành công! Đang chạy server..."
    java -jar target/ConCac-1.0-RELEASE-jar-with-dependencies.jar
else
    echo "Build thất bại! Vui lòng dùng IntelliJ IDEA."
fi

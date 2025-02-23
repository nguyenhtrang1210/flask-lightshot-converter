#!/bin/bash

# Tạo thư mục chrome
mkdir -p /opt/render/project/src/chrome

# Tải Google Chrome
echo "Tải Google Chrome..."
wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Giải nén Google Chrome
echo "Giải nén Google Chrome..."
dpkg -x google-chrome.deb /opt/render/project/src/chrome

# Tải ChromeDriver
echo "Tải ChromeDriver..."
CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"

# Giải nén ChromeDriver
echo "Giải nén ChromeDriver..."
unzip -o chromedriver_linux64.zip -d /opt/render/project/src/chrome

# Cấp quyền thực thi cho ChromeDriver
chmod +x /opt/render/project/src/chrome/chromedriver

# Kiểm tra ChromeDriver
echo "Kiểm tra ChromeDriver..."
/opt/render/project/src/chrome/chromedriver --version

# Chạy ứng dụng Flask
echo "Khởi chạy ứng dụng Flask..."
gunicorn main:app

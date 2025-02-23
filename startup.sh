#!/bin/bash

# Cài đặt các phụ thuộc cần thiết
echo "Cài đặt các phụ thuộc..."
apt update && apt install -y wget unzip gnupg2

# Thêm kho lưu trữ Google Chrome
echo "Thêm kho lưu trữ Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Cài đặt Google Chrome
echo "Cài đặt Google Chrome..."
apt update && apt install -y google-chrome-stable

# Kiểm tra phiên bản Chrome
echo "Kiểm tra Google Chrome..."
google-chrome --version

# Cài đặt ChromeDriver
echo "Cài đặt ChromeDriver..."
CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip -o chromedriver_linux64.zip
mv -f chromedriver /opt/render/project/src/chromedriver
chmod +x /opt/render/project/src/chromedriver

# Kiểm tra ChromeDriver
echo "Kiểm tra ChromeDriver..."
/opt/render/project/src/chromedriver --version

# Kiểm tra đường dẫn Chrome binary
echo "Kiểm tra đường dẫn Chrome binary..."
which google-chrome
ls -lah /usr/bin/google-chrome

# Chạy ứng dụng Flask
echo "Khởi chạy ứng dụng Flask..."
gunicorn main:app
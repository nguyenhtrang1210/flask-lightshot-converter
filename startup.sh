#!/bin/bash

# Cài đặt Google Chrome
echo "Installing Google Chrome..."
apt update && apt install -y wget unzip
wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome.deb || apt --fix-broken install -y

# Kiểm tra Google Chrome
google-chrome --version

# Cài đặt ChromeDriver
echo "Installing ChromeDriver..."
CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip"
unzip -o chromedriver_linux64.zip
mv -f chromedriver /opt/render/project/src/chromedriver
chmod +x /opt/render/project/src/chromedriver

# Kiểm tra xem ChromeDriver có tồn tại không
echo "Checking ChromeDriver installation..." >> log.txt
ls -lah /opt/render/project/src/chromedriver >> log.txt
/opt/render/project/src/chromedriver --version >> log.txt
cat log.txt

# Kiểm tra ChromeDriver đã cài chưa
/opt/render/project/src/chromedriver --version

# Chạy ứng dụng Flask
gunicorn main:app
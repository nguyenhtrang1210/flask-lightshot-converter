#!/bin/bash

# Cài đặt Google Chrome
echo "Installing Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable

# Kiểm tra phiên bản Chrome đã cài đặt
google-chrome --version

# Cài đặt ChromeDriver
echo "Installing ChromeDriver..."
LATEST_CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget "https://chromedriver.storage.googleapis.com/${LATEST_CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O chromedriver_linux64.zip

# Giải nén và di chuyển vào thư mục hệ thống
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/chromedriver
sudo chmod +x /usr/local/bin/chromedriver

# Kiểm tra phiên bản ChromeDriver đã cài đặt
chromedriver --version

# Chạy ứng dụng Flask
gunicorn main:app

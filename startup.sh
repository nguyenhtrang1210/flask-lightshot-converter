#!/bin/bash

# Cài đặt Chrome
echo "Cài đặt Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get update && apt-get install -y ./google-chrome-stable_current_amd64.deb

# Cài đặt ChromeDriver
echo "Cài đặt ChromeDriver..."
wget https://storage.googleapis.com/chrome-for-testing-public/133.0.0.0/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
chmod +x chromedriver-linux64/chromedriver
mv chromedriver-linux64/chromedriver /usr/local/bin/chromedriver

# Chạy ứng dụng
gunicorn main:app

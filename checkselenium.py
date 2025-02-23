from selenium import webdriver
from selenium.webdriver.chrome.service import Service
import os

# Đường dẫn đến ChromeDriver (CẬP NHẬT LẠI ĐƯỜNG DẪN CHÍNH XÁC)
CHROMEDRIVER_PATH = r"D:\python\2 - Flask\1_ConvertLink\chromedriver-win64\chromedriver.exe"

# Tạo service với đường dẫn ChromeDriver
service = Service(CHROMEDRIVER_PATH)
options = webdriver.ChromeOptions()
options.add_argument("--headless")  # Chạy ở chế độ không giao diện
options.add_argument("--no-sandbox")
options.add_argument("--disable-dev-shm-usage")

# Khởi tạo Chrome WebDriver với đường dẫn cụ thể
driver = webdriver.Chrome(service=service, options=options)

# Kiểm tra hoạt động
driver.get("https://www.google.com")
print("✅ ChromeDriver đã chạy thành công!")

# Đóng trình duyệt sau khi kiểm tra
driver.quit()

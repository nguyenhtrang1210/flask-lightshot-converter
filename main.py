from flask import Flask, render_template, request, jsonify, send_file
import os
import zipfile
import requests
import shutil
import chromedriver_autoinstaller
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from tqdm import tqdm
import traceback

app = Flask(__name__)

# Xử lý lỗi 500
@app.errorhandler(500)
def internal_server_error(e):
    error_message = traceback.format_exc()
    print(error_message)  # In lỗi ra terminal
    return jsonify({"status": "error", "message": "Lỗi server!", "details": error_message}), 500

# Thư mục lưu file upload & ảnh
UPLOAD_FOLDER = "uploads"
IMAGE_FOLDER = "images"

for folder in [UPLOAD_FOLDER, IMAGE_FOLDER]:
    if not os.path.exists(folder):
        os.makedirs(folder)

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
ALLOWED_EXTENSIONS = {"txt"}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Cấu hình Selenium với đường dẫn chính xác
chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
chromedriver_autoinstaller.install()  # Cài đặt Chromedriver nếu cần

options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--no-sandbox")

# Khởi tạo trình duyệt một lần để sử dụng lại
service = Service()
driver = webdriver.Chrome(service=service, options=options)

# Hàm tải ảnh từ danh sách URL
def crawl_images(urls, save_directory):
    driver = webdriver.Chrome(options=options)
    os.makedirs(save_directory, exist_ok=True)
    downloaded_files = []

    for url in tqdm(urls, desc="Downloading Images"):
        try:
            driver.get(url)
            image_elements = driver.find_elements(By.XPATH, "//img[contains(@class, 'no-click screenshot-image')]")
            if image_elements:
                image_url = image_elements[0].get_attribute("src")

                # Lấy đuôi URL gốc để đặt tên file
                img_ext = image_url.split(".")[-1]
                img_url_postfix = url.split("/")[-1]
                image_name = f'{img_url_postfix}.{img_ext}'

                image_path = os.path.join(save_directory, image_name)

                # Tải ảnh về
                image_data = requests.get(image_url).content
                with open(image_path, "wb") as file:
                    file.write(image_data)

                downloaded_files.append(image_path)
                print(f"✅ Đã tải: {image_name}")

        except Exception as e:
            print(f"❌ Lỗi khi tải {url}: {e}")

    driver.quit()
    return downloaded_files

# API Upload File & Xử lý
@app.route("/", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        if "file" not in request.files:
            return jsonify({"status": "error", "message": "Không tìm thấy file!"})

        file = request.files["file"]
        if file.filename == "" or not allowed_file(file.filename):
            return jsonify({"status": "error", "message": "Chỉ chấp nhận file định dạng .txt!"})

        # Xóa file cũ trước khi lưu file mới (chỉ cho phép 1 file tồn tại)
        for old_file in os.listdir(UPLOAD_FOLDER):
            os.remove(os.path.join(UPLOAD_FOLDER, old_file))

        # Lưu file mới vào thư mục uploads
        filepath = os.path.join(app.config["UPLOAD_FOLDER"], file.filename)
        file.save(filepath)

        # Đọc nội dung file & loại bỏ trùng lặp
        with open(filepath, "r", encoding="utf-8") as f:
            urls = list(set([line.strip() for line in f.readlines() if line.strip()]))

        if not urls:
            return jsonify({"status": "error", "message": "File không có nội dung hợp lệ!"})

        # Xóa ảnh cũ trước khi tải ảnh mới
        for old_image in os.listdir(IMAGE_FOLDER):
            os.remove(os.path.join(IMAGE_FOLDER, old_image))

        # Tải ảnh từ link
        downloaded_files = crawl_images(urls, IMAGE_FOLDER)

        # Tạo file ZIP chứa ảnh (nếu có ảnh)
        if downloaded_files:
            zip_filename = "images.zip"
            zip_filepath = os.path.join(IMAGE_FOLDER, zip_filename)

            with zipfile.ZipFile(zip_filepath, "w") as zipf:
                for file in downloaded_files:
                    zipf.write(file, os.path.basename(file))

            return jsonify({
                "status": "success",
                "message": "Tải ảnh thành công!",
                "download_url": "/download"
            })
        else:
            return jsonify({"status": "error", "message": "Không có ảnh nào được tải!"})

    return render_template("index.html")

# API Tải file ZIP
@app.route("/download", methods=["GET"])
def download():
    zip_filepath = os.path.join(IMAGE_FOLDER, "images.zip")
    if os.path.exists(zip_filepath):
        return send_file(zip_filepath, as_attachment=True)
    return "File không tồn tại", 404

if __name__ == "__main__":
    app.run(debug=True)

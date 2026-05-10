import os
from PIL import Image

def convert_to_webp(source_folder, quality=80):
    # 如果輸出資料夾不存在就建立一個
    output_folder = os.path.join(source_folder, "webp_output")
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # 支援的原始格式
    extensions = (".jpg", ".jpeg", ".png")

    for filename in os.listdir(source_folder):
        if filename.lower().endswith(extensions):
            # 讀取圖片
            img_path = os.path.join(source_folder, filename)
            img = Image.open(img_path)
            
            # 移除副檔名並加上 .webp
            name_without_ext = os.path.splitext(filename)[0]
            output_path = os.path.join(output_folder, f"{name_without_ext}.webp")

            # 轉檔並儲存 (quality 越高畫質越好，但檔案越大)
            img.save(output_path, "WEBP", quality=quality)
            print(f"已轉換: {filename} -> {name_without_ext}.webp")

if __name__ == "__main__":
    # 請將這裡改成你放照片的資料夾路徑
    target_dir = 'assets\except_webp' 
    
    if os.path.exists(target_dir):
        convert_to_webp(target_dir)
        print("\n所有照片轉換完成！請查看 webp_output 資料夾。")
    else:
        print("找不到指定的資料夾，請檢查路徑。")
# Happy-CCS

Công cụ cross-platform kết nối [CCS](https://github.com/kaitranntt/ccs) profiles với [Happy CLI](https://github.com/slopus/happy).

Chuyển đổi giữa các AI providers (Gemini, GLM, Kimi, v.v.) mà vẫn giữ nguyên các tính năng của Happy CLI (điều khiển mobile, daemon mode, thông báo, quản lý xác thực).

**[English](README.md)**

## Cài đặt

```bash
git clone https://github.com/thieung/dev-toolbox.git
cd dev-toolbox/happy-ccs
./install.sh        # Mac/Linux
install.cmd         # Windows
```

## Thiết lập

1. **Chuyển đến thư mục dự án:**
   ```bash
   cd /path/to/your/project
   ```

2. **Xác thực với thiết bị di động:**
   ```bash
   happy auth login          # Lần đầu
   happy auth login --force  # Xác thực lại
   ```

3. **Bắt đầu code với AI provider bạn chọn:**
   ```bash
   happy-ccs <profile>
   ```

## Cách sử dụng

```bash
happy-ccs --list              # Liệt kê các profiles
happy-ccs gemini              # Bắt đầu với Gemini
happy-ccs glm --resume        # Tiếp tục session với GLM
happy-ccs kimi daemon start   # Chế độ daemon với Kimi
happy-ccs gemini --dry-run    # Test (hiển thị lệnh mà không chạy)
```

## Gỡ cài đặt

```bash
npm uninstall -g happy-ccs
```

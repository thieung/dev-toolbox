# Happy-CCS

Công cụ cross-platform kết nối [CCS](https://github.com/kaitranntt/ccs) profiles với [Happy CLI](https://github.com/slopus/happy).

Chuyển đổi giữa các AI providers (Gemini, GLM, Kimi, v.v.) mà vẫn giữ nguyên các tính năng của Happy CLI (điều khiển mobile, daemon mode, thông báo, quản lý xác thực).

**[English](README.md)**

## Yêu cầu

**Bắt buộc:** Cài đặt [Git](https://git-scm.com), [Node.js](https://nodejs.org) (với npm), và [Claude Code](https://code.claude.com/docs/en/setup) trước.

Script cài đặt sẽ tự động cài các CLI tools nếu thiếu:
- **[CCS](https://github.com/kaitranntt/ccs)**
- **[Happy CLI](https://github.com/slopus/happy)**

## Cài đặt

```bash
# Clone và di chuyển vào thư mục
git clone https://github.com/thieung/dev-toolbox.git
cd dev-toolbox/happy-ccs

# Mac/Linux
./install.sh

# Windows PowerShell (chạy as Administrator nếu cần)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
.\install.ps1

# Windows CMD (chạy as Administrator nếu cần)
install.cmd
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

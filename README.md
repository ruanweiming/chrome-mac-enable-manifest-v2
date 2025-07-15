# 🛠 解决 macOS Chrome 报错：“此扩展程序不再受支持，因此已停用”

## 📌 背景说明

从 Chrome 138 开始，macOS 上的 `chrome://flags` 页面已移除对 Manifest V2 的启用开关，
用户无法再通过 Flags 恢复旧版扩展支持。

如果你在使用某些老旧扩展时看到如下提示：

> 此扩展程序不再受支持，因此已停用。

你可以使用以下两种方式启用 Manifest V2 支持。

---

## ✅ 方法一：终端命令（临时有效）

适合调试用途，重启后失效：

```bash
sudo bash <<'EOF'
PLIST_PATH="/Library/Managed Preferences/com.google.Chrome.plist"

echo "🔧 Enabling Chrome Manifest V2 Extension Support..."

sudo mkdir -p "/Library/Managed Preferences"

sudo tee "$PLIST_PATH" >/dev/null <<EOP
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ExtensionManifestV2Availability</key>
  <integer>2</integer>
</dict>
</plist>
EOP

sudo chmod 644 "$PLIST_PATH"
sudo chown root:wheel "$PLIST_PATH"

echo "✅ Chrome Manifest V2 support enabled. Please restart Chrome."
EOF

killall "Google Chrome"
open -a "Google Chrome"
```

---

## ✅ 方法二：安装描述文件（永久有效）

1. 双击 `chrome-manifestv2.mobileconfig` 文件
2. 进入“系统设置 > 描述文件”，点击安装并输入密码
3. 重启 Chrome
4. 打开 `chrome://policy`，应看到 `ExtensionManifestV2Availability = 2`

如需卸载描述文件：

```bash
sudo profiles remove -identifier com.local.chrome.policies
```

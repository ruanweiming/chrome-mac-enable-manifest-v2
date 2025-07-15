# 🛠 Fix macOS Chrome Error: “This extension is no longer supported and has been disabled”
🔄 中文版说明请见：[README-中文.md](./README-中文.md)
## 📌 Background

Starting from Chrome 138 on macOS, the `chrome://flags` page no longer includes any toggle
to re-enable Manifest V2 support.

If you see the following message while using certain extensions like uBlock Origin:

> This Extension Was Turned Off Because It's No Longer Supported.

You can fix it using one of the two methods below.

---

## ✅ Option 1: Terminal Command (Temporary)

Use this for development or testing. This setting will reset after reboot:

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

## ✅ Option 2: Install Profile (Permanent)
📥 [Download Configuration Profile (chrome-manifestv2.mobileconfig)](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/1.0/chrome-manifestv2.mobileconfig)
1. Double-click `chrome-manifestv2.mobileconfig`
2. Open System Settings > Profiles
3. Click Install and enter your password
4. Relaunch Chrome
5. Visit `chrome://policy` to verify `ExtensionManifestV2Availability = 2`

To remove the profile:

```bash
sudo profiles remove -identifier com.local.chrome.policies
```

#!/bin/bash

# Chrome Manifest V2 Extension Support Enabler for macOS
# 启用 macOS 下对 Chrome Manifest V2 扩展支持的脚本

PLIST_PATH="/Library/Managed Preferences/com.google.Chrome.plist"

echo "🔧 Enabling Chrome Manifest V2 Extension Support..."

# Create target directory if not exist
sudo mkdir -p "/Library/Managed Preferences"

# Write managed preference plist
sudo tee "$PLIST_PATH" >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ExtensionManifestV2Availability</key>
  <integer>2</integer>
</dict>
</plist>
EOF

# Set proper permissions
sudo chmod 644 "$PLIST_PATH"
sudo chown root:wheel "$PLIST_PATH"

# Optional: Refresh preference cache
# sudo killall cfprefsd

echo "✅ Chrome Manifest V2 support enabled. Please restart Chrome."

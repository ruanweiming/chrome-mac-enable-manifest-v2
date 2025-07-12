# macOS 下启用 Chrome Manifest V2 扩展支持
本项目用于解决 macOS 上 Chrome 浏览器中部分扩展（如广告拦截器）被禁用的问题，原因是 Google 正在逐步淘汰 Manifest V2 扩展格式。在 macOS Chrome 138 版本中，chrome://flags 页面没有 chrome://flags/#extension-manifest-v2-deprecation-disabled 和 chrome://flags/#extension-manifest-v2-deprecation-unsupported 这两个选项，因此本方案通过系统策略绕过限制，起到了启用 Manifest V2 扩展的作用。

## English Documentation

If you prefer the English version, please click here:  
[English Version](README.en.md)

## 🚨 问题现象

你可能在 Chrome 中看到类似以下提示：

- “此扩展程序不再受支持，因此已停用。”
- “这些扩展程序可能很快将不再受支持。”

这通常是因为该扩展仍基于 Manifest V2，而 Google 正在强制推广 Manifest V3。

## ✅ 解决方案

使用 macOS 的 **受管理策略**（Managed Preferences），强制允许 Chrome 继续加载 Manifest V2 扩展。

## 📦 主要操作

脚本将会：

- 向 `/Library/Managed Preferences/com.google.Chrome.plist` 写入配置文件
- 设置键值 `ExtensionManifestV2Availability = 2`，允许加载所有 V2 扩展

## 📋 使用方法

```bash
chmod +x enable-chrome-v2.sh
sudo ./enable-chrome-v2.sh
```

然后重启 Chrome 浏览器。

## 🔁 恢复默认设置

若想撤销此设置，运行：

```bash
sudo rm /Library/Managed\ Preferences/com.google.Chrome.plist
```

## 🧠 注意事项

- 仅适用于 macOS 上的 Google Chrome，不支持 Chromium 或其他浏览器。
- 在 macOS Ventura 和 Sonoma 上测试通过。

## 📄 许可证

MIT

## 💡 小技巧：无需保存脚本文件

如果你只是临时使用，也可以直接在终端粘贴以下内容，无需保存成 `.sh` 文件：

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
```

## ✅ 如何验证是否生效

打开 Chrome，输入地址：

```
chrome://policy
```

点击“重新加载策略（Reload policies）”，确认是否出现：
```
ExtensionManifestV2Availability = 2
```

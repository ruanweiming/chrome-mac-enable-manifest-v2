# 🛠 解决 macOS Chrome “此扩展程序不再受支持” 提示

🔄 For English version, see: `README-EN.md`

---

## 📌 背景说明

- 从 **Chrome 138** 开始，macOS 上的 `chrome://flags` 已移除对 Manifest V2 的启用开关。  
- Windows 下可通过注册表恢复 Manifest V2 支持，但 macOS 没有注册表机制，只能通过 **描述文件（mobileconfig）**、**终端命令** 或 **启动参数**。  
- 如果你在使用某些扩展（如 *uBlock Origin*）时看到以下提示：  

```
此扩展程序不再受支持，因此已停用。
```

请注意：

- 在 **Chrome 140+**：官方彻底移除 V2 Flags 与 Policy，目前唯一可行方案是 **方法一（启动参数/脚本）**。  
- 在 **Chrome 138/139**：仍可用历史方法（二、三）。  

---

## ✅ 方法一：终端命令 & 脚本 App（适用于 Chrome 140+，推荐）

**方式一：直接用终端启动**  
在终端中运行以下命令：

```bash
open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled
```

这样会启动一个支持 Manifest V2 扩展的 Chrome 实例。  

---

**方式二：快捷方式**  

📥 [下载 Chrome V2 快捷方式](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/2.0/Chrome.V2.app.zip)

使用步骤：  

1. 下载并解压 `Chrome V2.app` 到 **应用程序** 文件夹  
2. 拖入 Dock，以后直接点图标即可启动支持 V2 扩展的 Chrome  

**⚠️ 首次运行若提示「已损坏或不完整」**  

- 方法一：右键 → 打开 → 仍要打开（只需一次）  

- 方法二：终端执行  

  ```bash
  xattr -d com.apple.quarantine "/Applications/Chrome V2.app"
  ```

**自己创建脚本编辑器**  
1. 打开 **应用程序 → 实用工具 → Script Editor (脚本编辑器)**  

2. 新建文稿，粘贴以下内容：

   ```applescript
   do shell script "open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
   ```

3. 菜单栏 → **文件 → 存储**  

   - 名称：`Chrome V2`  
   - 位置：应用程序  
   - 格式：应用程序  

4. 在 Finder 中找到 `Chrome V2.app` → 右键 → **显示简介**  

   - 可复制原版 Chrome 图标，或自定义图标  

5. 将 `Chrome V2.app` 拖入 Dock，今后直接点击即可运行支持 V2 扩展的 Chrome  
---

## ⚠️ 方法二：Flags（仅适用于 Chrome 138/139）

> 在 Chrome 139.0.7258.67（arm64）验证可用，但 **Chrome 140+ 已失效**

1. 打开：`chrome://flags/#temporary-unexpire-flags-m137` → **Enabled**  
2. 重启 Chrome  
3. 配置以下 Flags：  
   - `chrome://flags/#extension-manifest-v2-deprecation-warning` → **Disabled**  
   - `chrome://flags/#extension-manifest-v2-deprecation-disabled` → **Disabled**  
   - `chrome://flags/#extension-manifest-v2-deprecation-unsupported` → **Disabled**  
   - `chrome://flags/#allow-legacy-mv2-extensions` → **Enabled**  
4. 再次重启 Chrome  

---

## ⚠️ 方法三：终端命令（历史方案，仅参考）

适用于 Chrome 138/139，**Chrome 140+ 已失效**

```bash
sudo bash <<'EOF'
PLIST_PATH="/Library/Managed Preferences/com.google.Chrome.plist"

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

## ⚠️ 方法四：描述文件（历史方案，仅参考）

适用于 Chrome 138/139，**Chrome 140+ 已失效**

📥 [下载配置描述文件]([https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/2.0/Chrome.V2.app.zip](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/1.0/chrome-manifestv2.mobileconfig))

1. 双击 `chrome-manifestv2.mobileconfig`  
2. 系统设置 → 描述文件 → 安装并输入密码  
3. 重启 Chrome  
4. 打开 `chrome://policy`，应看到：

```
ExtensionManifestV2Availability = 2
```

**卸载描述文件：**

```bash
sudo profiles remove -identifier com.local.chrome.policies
```

---

## 📌 总结

- **Chrome 140+**：优先推荐 **终端命令** 或 **预制 App（方法一）**。  
- **Chrome 138/139**：方法二、三、四可用，但已不适用于新版。  
- **预制 App** 适合长期使用，可固定 Dock 并设置图标。  

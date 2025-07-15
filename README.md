# 🛠 解决 macOS Chrome 报错：“此扩展程序不再受支持，因此已停用”
# 🛠 Fix macOS Chrome Error: “This extension is no longer supported and has been disabled”

---

## 📌 问题背景 | Background

在 macOS 上运行旧版 Manifest V2 Chrome 扩展时，Chrome 可能会强制禁用扩展并提示：

> **“此扩展程序不再受支持，因此已停用。”**  
> _“This extension is no longer supported and has been disabled.”_

### ❗关于 Chrome 138 版本的说明

在 macOS 的 Chrome 138+ 版本中，**`chrome://flags` 页面已移除 Manifest V2 弃用相关设置项**（如 "Extensions Manifest V2 deprecation"），这意味着：

- **用户无法再通过 Flags 页面重新启用 Manifest V2；**
- **只能通过系统级策略注入（如本项目提供的方式）来强制启用 Manifest V2 支持。**

---

## ✅ 解决方案 | Solutions

### 🧩 方案一：终端执行命令（临时有效）
### 🧩 Option 1: Terminal Command (Temporary Fix)

适合开发调试或短期使用，重启后失效。

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

```bash
killall "Google Chrome"
open -a "Google Chrome"
```

访问 `chrome://policy`，应看到：

```
ExtensionManifestV2Availability    2    Platform
```

⚠️ **此方法仅在当前会话中生效，重启 macOS 后失效。**

---

### 🛡 方案二：安装配置描述文件（永久生效）
### 🛡 Option 2: Install Configuration Profile (Permanent Fix)

推荐用于长期使用或企业内管理环境。

### 🛡 安装方式一：图形界面（推荐给普通用户）

1. 双击文件：`chrome-manifestv2.mobileconfig`
2. 系统会弹出“系统设置 > 描述文件”界面
3. 点击“安装”并输入管理员密码
4. 完成后退出并重新打开 Chrome，即可恢复 Manifest V2 支持

### 🛡 安装方式二：命令行（开发者/运维推荐）

```bash
sudo profiles install -type configuration -path ./profile/chrome-manifestv2.mobileconfig
```

安装命令：

```bash
sudo profiles install -type configuration -path ./profile/chrome-manifestv2.mobileconfig
```

```bash
killall "Google Chrome"
open -a "Google Chrome"
```

访问 `chrome://policy` 页面，确认策略已应用。

---

## 🔄 可选：卸载配置文件 | Optional: Remove Profile

```bash
sudo profiles remove -identifier com.local.chrome.policies
```

---

## 📁 项目结构 | Project Structure

| 路径 | 描述 |
|------|------|
| `profile/chrome-manifestv2.mobileconfig` | 配置描述文件，永久方案使用 |
| `README.md` | 项目说明与命令操作指南 |

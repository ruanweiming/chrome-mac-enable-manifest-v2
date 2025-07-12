# Chrome Manifest V2 Extension Enabler for macOS

This script enables support for **Manifest V2 Chrome extensions** (such as ad blockers like uBlock Origin) on macOS systems where Google has started phasing them out. On macOS Chrome version 138, the chrome://flags page does not include the flags chrome://flags/#extension-manifest-v2-deprecation-disabled and chrome://flags/#extension-manifest-v2-deprecation-unsupported. Therefore, this solution uses system managed preferences to bypass this limitation and enable Manifest V2 extensions.

## 中文说明

如果你需要中文版，请点击这里：  
[中文版](README.md)

## 🚨 Problem

Google Chrome on macOS may show messages like:

- "This extension is no longer supported and has been disabled."
- "These extensions may soon stop working."

This is due to Google's deprecation of Manifest V2. Many extensions, especially content blockers, are still using this older format.

## ✅ Solution

This script uses a **managed preference policy** to override Chrome’s default behavior and allow all Manifest V2 extensions.

## 📦 What It Does

- Writes a plist configuration to `/Library/Managed Preferences/com.google.Chrome.plist`
- Sets `ExtensionManifestV2Availability = 2` (allow all V2 extensions)

## 📋 Usage

```bash
chmod +x enable-chrome-v2.sh
sudo ./enable-chrome-v2.sh
```

Then restart Chrome.

## 🔁 Reverting the Change

To revert, simply delete the plist file:

```bash
sudo rm /Library/Managed\ Preferences/com.google.Chrome.plist
```

## 🧠 Notes

- Tested on macOS Sonoma and Ventura.
- Only works on Chrome, not Chromium or other variants.

## 📄 License

MIT

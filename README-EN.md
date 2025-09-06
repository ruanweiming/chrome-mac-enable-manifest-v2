# 🛠 Fixing macOS Chrome "This extension is no longer supported" Warning

🔄 For Chinese version, see: `README.md`

------------------------------------------------------------------------

## 📌 Background

-   Starting with **Chrome 138**, the `chrome://flags` option to enable
    Manifest V2 on macOS has been removed.\
-   On Windows, Manifest V2 support can be restored via Registry. macOS
    doesn't have a registry, so you must use **configuration profiles
    (mobileconfig)**, **terminal commands**, or **startup parameters**.\
-   If you see the following prompt when using certain extensions (like
    *uBlock Origin*):

```{=html}
<!-- -->
```

    This extension is no longer supported and has been disabled.

Take note:

-   On **Chrome 140+**: Google completely removed V2 flags and policies.
    The only working method is **Method 1 (startup
    parameters/scripts)**.\
-   On **Chrome 138/139**: Historical methods (2 and 3) still work.

------------------------------------------------------------------------

## ✅ Method 1: Terminal Command & Script App (Works on Chrome 140+, Recommended)

**Option A: Directly via Terminal**\
Run the following command in Terminal:

``` bash
open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled
```

This launches Chrome with Manifest V2 extensions enabled.

------------------------------------------------------------------------

**Option B: Shortcut App**

📥 [Download Chrome V2
Shortcut](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/2.0/Chrome.V2.app.zip)

Steps:

1.  Download and unzip `Chrome V2.app` to your **Applications** folder\
2.  Drag it into the Dock and launch directly with V2 support

**⚠️ If you see "App is damaged or incomplete"**

- Option 1: Right-click → Open → Still Open (only once)\

- Option 2: Run in Terminal:

  ``` bash
  xattr -d com.apple.quarantine "/Applications/Chrome V2.app"
  ```

**Create your own Script App**

1. Open **Applications → Utilities → Script Editor**\

2. Paste the following:

   ``` applescript
   do shell script "open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
   ```

3. Save as Application, name it `Chrome V2`, and place in Applications\

4. Customize the icon if desired\

5. Drag to Dock for quick launch

------------------------------------------------------------------------

## ⚠️ Method 2: Flags (Chrome 138/139 Only)

> Verified on Chrome 139.0.7258.67 (arm64). **Not available on Chrome
> 140+**.

1.  Open: `chrome://flags/#temporary-unexpire-flags-m137` → **Enabled**\
2.  Restart Chrome\
3.  Configure the following Flags:
    -   `chrome://flags/#extension-manifest-v2-deprecation-warning` →
        **Disabled**\
    -   `chrome://flags/#extension-manifest-v2-deprecation-disabled` →
        **Disabled**\
    -   `chrome://flags/#extension-manifest-v2-deprecation-unsupported`
        → **Disabled**\
    -   `chrome://flags/#allow-legacy-mv2-extensions` → **Enabled**\
4.  Restart Chrome again

------------------------------------------------------------------------

## ⚠️ Method 3: Terminal Command (Legacy, Chrome 138/139)

No longer works on Chrome 140+. Example:

``` bash
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

------------------------------------------------------------------------

## ⚠️ Method 4: Profile (Legacy, Chrome 138/139)

Also removed in Chrome 140+.

📥 [Download Configuration
Profile](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/1.0/chrome-manifestv2.mobileconfig)

1.  Double-click the `.mobileconfig` file\
2.  Go to **System Settings → Profiles → Install**\
3.  Restart Chrome\
4.  Verify in `chrome://policy`:

```{=html}
<!-- -->
```

    ExtensionManifestV2Availability = 2

**Uninstall profile**:

``` bash
sudo profiles remove -identifier com.local.chrome.policies
```

------------------------------------------------------------------------

## 📌 Summary

-   **Chrome 140+**: Only Method 1 (Terminal/Shortcut) works\
-   **Chrome 138/139**: Methods 2--4 may still work\
-   **Shortcut app** is best for daily use (Dock launch with custom
    icon)


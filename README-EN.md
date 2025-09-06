# 🛠 Fixing macOS Chrome "This extension was turned off because it's no longer supported" Prompt

------------------------------------------------------------------------

## 📌 Background

-   Starting from **Chrome 138**, macOS removed the flag in
    `chrome://flags` that allowed enabling Manifest V2.\
-   On Windows, Manifest V2 support can still be restored through the
    Registry, but macOS has no such mechanism. Instead, you can use
    **configuration profiles (mobileconfig)**, **terminal commands**, or
    **startup parameters**.\
-   If you see the following message when using extensions (e.g.,
    *uBlock Origin*):

    This extension was turned off because it's no longer supported

Please note:

-   On **Chrome 140+**: Google has completely removed V2 Flags and
    Policy. The only working method is **Method 1 (startup
    parameters/script)**.\
-   On **Chrome 138/139**: legacy methods (2 and 3) still work.

------------------------------------------------------------------------

## ✅ Method 1: Terminal Command & Script App (For Chrome 140+, Recommended)

**Option A: Direct terminal launch**\
Run this in Terminal:

``` bash
open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled
```

This starts Chrome with Manifest V2 support.

------------------------------------------------------------------------

**Option B: Shortcut App**

📥 [Download Chrome V2
Shortcut](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/2.0/Chrome.V2.app.zip)

Steps:

1.  Download and unzip `Chrome V2.app` into the **Applications** folder\
2.  Drag it into your Dock, then simply click the icon to run Chrome
    with V2 support

**⚠️ First launch may show "Damaged or incomplete" warning**

- Option 1: Right-click → Open → Still Open (once only)\

- Option 2: Run in Terminal:

  ``` bash
  xattr -d com.apple.quarantine "/Applications/Chrome V2.app"
  ```

**Create your own script app:**

1. Open **Applications → Utilities → Script Editor**\

2. Paste the following:

   ``` applescript
   do shell script "open -b com.google.Chrome --new --args --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
   ```

3. File → Save →

   -   Name: `Chrome V2`\
   -   Location: Applications\
   -   File Format: Application

4. In Finder, right-click `Chrome V2.app` → **Get Info** → Replace the
   icon if desired\

5. Drag `Chrome V2.app` into the Dock for quick access

------------------------------------------------------------------------

## ⚠️ Method 2: Flags (For Chrome 138/139 Only)

> Verified on Chrome 139.0.7258.67 (arm64). **Not available on Chrome
> 140+.**

1.  Open: `chrome://flags/#temporary-unexpire-flags-m137` → **Enabled**\
2.  Restart Chrome\
3.  Configure the following flags:
    -   `chrome://flags/#extension-manifest-v2-deprecation-warning` →
        **Disabled**\
    -   `chrome://flags/#extension-manifest-v2-deprecation-disabled` →
        **Disabled**\
    -   `chrome://flags/#extension-manifest-v2-deprecation-unsupported`
        → **Disabled**\
    -   `chrome://flags/#allow-legacy-mv2-extensions` → **Enabled**\
4.  Restart Chrome again

------------------------------------------------------------------------

## ⚠️ Method 3: Terminal Command (Legacy, Chrome 138/139 Only)

**Not valid on Chrome 140+**

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

## ⚠️ Method 4: Configuration Profile (Legacy, Chrome 138/139 Only)

**Not valid on Chrome 140+**

📥 [Download mobileconfig
profile](https://github.com/ruanweiming/chrome-mac-enable-manifest-v2/releases/download/1.0/chrome-manifestv2.mobileconfig)

Steps:

1.  Double-click `chrome-manifestv2.mobileconfig`\
2.  System Settings → Profiles → Install and enter password\
3.  Restart Chrome\
4.  Open `chrome://policy` → Check:

```{=html}
<!-- -->
```

    ExtensionManifestV2Availability = 2

**Uninstall profile:**

``` bash
sudo profiles remove -identifier com.local.chrome.policies
```

------------------------------------------------------------------------

## 📌 Summary

-   **Chrome 140+**: Use **Method 1 (Terminal or Shortcut App)**.\
-   **Chrome 138/139**: Methods 2--4 still work, but not for newer
    versions.\
-   **Shortcut App** is best for daily use---can be pinned in Dock with
    custom icon.


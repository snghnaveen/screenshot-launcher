#!/bin/bash
set -e

APP_NAME="ScreenshotLauncher"
OUTPUT_DIR="assets/app"
BUNDLE_NAME="$OUTPUT_DIR/$APP_NAME.app"

echo "🧹 Cleaning previous builds..."
# Clean build folder and previous app bundle
rm -rf .build || true
rm -rf "$BUNDLE_NAME" || true

ZIP_NAME="$APP_NAME.zip"
DMG_NAME="$APP_NAME.dmg"
DMG_TEMP="./build/dmg_temp"

echo "🔨 Building the executable in release mode..."
swift build -c release

echo "📦 Creating app bundle structure..."
mkdir -p "$BUNDLE_NAME/Contents/MacOS"
mkdir -p "$BUNDLE_NAME/Contents/Resources"

echo "📂 Copying files..."
cp ".build/release/$APP_NAME" "$BUNDLE_NAME/Contents/MacOS/"
cp "Info.plist" "$BUNDLE_NAME/Contents/"
cp "ScreenshotLauncherIcon.icns" "$BUNDLE_NAME/Contents/Resources/"

echo "🔧 Setting executable permissions..."
chmod +x "$BUNDLE_NAME/Contents/MacOS/$APP_NAME"

echo "🗜️ Creating zip archive..."
(cd "$OUTPUT_DIR" && zip -r -q "../../$ZIP_NAME" "$APP_NAME.app")

echo "📀 Creating DMG with Applications shortcut..."
rm -rf "$DMG_TEMP"
mkdir -p "$DMG_TEMP"
cp -R "$BUNDLE_NAME" "$DMG_TEMP/"

# Add Applications shortcut for drag-and-drop
ln -s /Applications "$DMG_TEMP/Applications"

# Create compressed DMG (UDZO)
hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_TEMP" -ov -format UDZO "$DMG_NAME"

# Cleanup
rm -rf "$DMG_TEMP"

echo "✅ Build complete!"
echo "App bundle: $BUNDLE_NAME"
echo "Zip archive: $ZIP_NAME"
echo "DMG: $DMG_NAME"

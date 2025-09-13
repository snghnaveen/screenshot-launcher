#!/bin/bash
set -e

APP_NAME="ScreenshotLauncher"
OUTPUT_DIR="assets/app"
BUNDLE_NAME="$OUTPUT_DIR/$APP_NAME.app"

echo "🧹 Cleaning previous builds..."
# Clean build folder and previous app bundle
rm -rf .build || true
rm -rf "$BUNDLE_NAME" || true

echo "🔨 Building the executable in release mode..."
swift build -c release

echo "📦 Creating app bundle structure..."
mkdir -p "$BUNDLE_NAME/Contents/MacOS"
mkdir -p "$BUNDLE_NAME/Contents/Resources"

echo "📂 Copying files..."
# Copy the executable
cp ".build/release/$APP_NAME" "$BUNDLE_NAME/Contents/MacOS/"

# Copy Info.plist
cp "Info.plist" "$BUNDLE_NAME/Contents/"

# Copy icon
cp "ScreenshotLauncherIcon.icns" "$BUNDLE_NAME/Contents/Resources/"

echo "🔧 Setting executable permissions..."
chmod +x "$BUNDLE_NAME/Contents/MacOS/$APP_NAME"

echo "✅ Build complete: $BUNDLE_NAME"

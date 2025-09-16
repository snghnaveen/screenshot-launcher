#!/bin/bash
set -e

APP_NAME="ScreenshotLauncher"
OUTPUT_DIR=".build/app"
UNIVERSAL_DIR=".build/universal"
DMG_TEMP=".build/dmg_temp"
DIST_DIR="dist"

echo "🧹 Cleaning previous builds..."
rm -rf .build || true
rm -rf "$OUTPUT_DIR" || true
rm -rf "$DMG_TEMP" || true
rm -rf "$DIST_DIR" || true
mkdir -p "$OUTPUT_DIR"
mkdir -p "$UNIVERSAL_DIR"
mkdir -p "$DIST_DIR"

# --- Build for both architectures ---
echo "🔨 Building for arm64..."
swift build -c release --arch arm64

echo "🔨 Building for x86_64..."
swift build -c release --arch x86_64

# --- Create universal binary ---
echo "🧩 Creating universal binary with lipo..."
lipo -create \
    .build/arm64-apple-macosx/release/$APP_NAME \
    .build/x86_64-apple-macosx/release/$APP_NAME \
    -output "$UNIVERSAL_DIR/$APP_NAME"

# Function to package app into .app, .zip, .dmg
package_app() {
    local ARCH=$1
    local BINARY=$2
    local ARCH_OUTPUT="$OUTPUT_DIR/$ARCH"
    local BUNDLE_NAME="$ARCH_OUTPUT/$APP_NAME.app"

    echo "📦 Creating $ARCH app bundle..."
    mkdir -p "$BUNDLE_NAME/Contents/MacOS"
    mkdir -p "$BUNDLE_NAME/Contents/Resources"

    cp "$BINARY" "$BUNDLE_NAME/Contents/MacOS/$APP_NAME"
    cp "Info.plist" "$BUNDLE_NAME/Contents/"
    cp "ScreenshotLauncherIcon.icns" "$BUNDLE_NAME/Contents/Resources/"
    chmod +x "$BUNDLE_NAME/Contents/MacOS/$APP_NAME"

    # Create zip
    ZIP_NAME="$APP_NAME-$ARCH.zip"
    echo "🗜️ Creating $ZIP_NAME..."
    (cd "$ARCH_OUTPUT" && zip -r -q "../../../$DIST_DIR/$ZIP_NAME" "$APP_NAME.app")

    # Create dmg
    DMG_NAME="$APP_NAME-$ARCH.dmg"
    echo "📀 Creating $DMG_NAME..."
    rm -rf "$DMG_TEMP"
    mkdir -p "$DMG_TEMP"
    cp -R "$BUNDLE_NAME" "$DMG_TEMP/"
    ln -s /Applications "$DMG_TEMP/Applications"

    hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_TEMP" -ov -format UDZO "$DIST_DIR/$DMG_NAME"

    rm -rf "$DMG_TEMP"

    echo "✅ $ARCH build complete: $BUNDLE_NAME"
    echo "   ├─ ZIP: $DIST_DIR/$ZIP_NAME"
    echo "   └─ DMG: $DIST_DIR/$DMG_NAME"
}

# --- Package for each architecture ---
package_app "arm64" ".build/arm64-apple-macosx/release/$APP_NAME"
package_app "x86_64" ".build/x86_64-apple-macosx/release/$APP_NAME"
package_app "universal" "$UNIVERSAL_DIR/$APP_NAME"

echo "🎉 All builds complete!"
echo "📦 Distributables located in: $DIST_DIR/"

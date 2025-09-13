# ScreenshotLauncher

**ScreenshotLauncher** is a lightweight macOS menu bar app that provides quick access to the built-in Screenshot utility. It runs as a status bar item and allows you to open the Screenshot app with a single click.  

![Screen](assets/screen.gif)  

---

## Features

- **Status Bar Icon**: Appears in the macOS menu bar with a camera icon.  
- **Quick Screenshot Access**: Left-clicking the icon opens `/System/Applications/Utilities/Screenshot.app`.  
- **Context Menu**: Right-click the icon to show a menu with a “Quit” option.  
- **Lightweight**: Runs without a dock icon, keeping your workflow clean.  

---

## Installation

You can either build the app yourself or download a prebuilt version:

### Option 1: Build from source (optional)
1. Clone the repository:
    ```bash
    git clone https://github.com/snghnaveen/screenshot-launcher.git
    cd screenshot-launcher
    ```
2. Build the app using the included script:
    ```bash
    ./build.sh
    ```
3. The `.app` bundle will be generated in:
    ```bash
    assets/app/ScreenshotLauncher.app
    ```
4. Open the app by double-clicking it, or move it to the Applications folder if you want it available system-wide.

### Option 2: Download prebuilt ZIP
Download the latest release from the repository:

[Download ScreenshotLauncher.zip](ScreenshotLauncher.zip)

> After downloading, unzip the file and move `ScreenshotLauncher.app` to your Applications folder or run it directly.

---

### Usage
- Left-Click: Opens the macOS Screenshot utility.
- Right-Click: Opens the menu with option “Quit”.

---

## Motivation

I used to rely on the MacBook Touch Bar, where I could keep a dedicated icon for quickly taking screenshots.  
When I started using a Mac without a Touch Bar, I found myself constantly pressing keyboard shortcuts to access the Screenshot utility.  

To make my workflow easier and more convenient, I built **ScreenshotLauncher** to keep a clickable screenshot icon in the macOS menu bar.

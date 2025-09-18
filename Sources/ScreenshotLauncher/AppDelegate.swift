import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var menu: NSMenu?
    var pendingTask: DispatchWorkItem?
    var countdownTimer: Timer?
    var activeMenuItem: NSMenuItem?

    // Keep references to items so we can reset
    var nowItem: NSMenuItem!
    var twoSecItem: NSMenuItem!
    var fiveSecItem: NSMenuItem!
    var tenSecItem: NSMenuItem!
    var fifteenSecItem: NSMenuItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "camera.fill", accessibilityDescription: "Screenshot")
            button.target = self
            button.action = #selector(leftClickAction)
        }

        // Create menu items
        nowItem = NSMenuItem(title: "Open Screenshot Now", action: #selector(openNow), keyEquivalent: "")
        twoSecItem = NSMenuItem(title: "Open Screenshot in 2s", action: #selector(openIn2s), keyEquivalent: "")
        fiveSecItem = NSMenuItem(title: "Open Screenshot in 5s", action: #selector(openIn5s), keyEquivalent: "")
        tenSecItem = NSMenuItem(title: "Open Screenshot in 10s", action: #selector(openIn10s), keyEquivalent: "")
        fifteenSecItem = NSMenuItem(title: "Open Screenshot in 15s", action: #selector(openIn15s), keyEquivalent: "")

        // Build menu
        menu = NSMenu()
        menu?.addItem(nowItem)
        menu?.addItem(twoSecItem)
        menu?.addItem(fiveSecItem)
        menu?.addItem(tenSecItem)
        menu?.addItem(fifteenSecItem)
        menu?.addItem(.separator())
        menu?.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        // Track right-click events
        NSEvent.addLocalMonitorForEvents(matching: [.rightMouseUp]) { [weak self] event in
            guard let self = self else { return event }
            self.showMenu()
            return nil
        }
    }

    @objc func leftClickAction() {
        launchScreenshotApp()
    }

    private func launchScreenshotApp() {
        let path = "/System/Applications/Utilities/Screenshot.app"
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
    }

    private func scheduleLaunch(after delay: Int, menuItem: NSMenuItem) {
        // Cancel existing task and countdown
        pendingTask?.cancel()
        countdownTimer?.invalidate()
        resetMenuTitles()

        // Immediate launch
        guard delay > 0 else {
            launchScreenshotApp()
            return
        }

        // Track active item
        activeMenuItem = menuItem

        // Schedule the launch
        let task = DispatchWorkItem { [weak self] in
            self?.launchScreenshotApp()
            self?.resetMenuTitles()
        }
        pendingTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: task)

        // Start countdown
        var remaining = delay
        updateMenuItemTitle(menuItem, seconds: remaining)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            remaining -= 1
            if remaining > 0 {
                self.updateMenuItemTitle(menuItem, seconds: remaining)
            } else {
                timer.invalidate()
            }
        }
    }

    private func updateMenuItemTitle(_ item: NSMenuItem, seconds: Int) {
        item.title = "Opening Screenshot in \(seconds)s..."
    }

    private func resetMenuTitles() {
        countdownTimer?.invalidate()
        activeMenuItem = nil

        nowItem.title = "Open Screenshot Now"
        fiveSecItem.title = "Open Screenshot in 5s"
        tenSecItem.title = "Open Screenshot in 10s"
        fifteenSecItem.title = "Open Screenshot in 15s"
    }

    // Menu actions
    @objc func openNow() {
        scheduleLaunch(after: 0, menuItem: nowItem)
    }

    @objc func openIn2s() {
        scheduleLaunch(after: 2, menuItem: fiveSecItem)
    }

    @objc func openIn5s() {
        scheduleLaunch(after: 5, menuItem: fiveSecItem)
    }

    @objc func openIn10s() {
        scheduleLaunch(after: 10, menuItem: tenSecItem)
    }

    @objc func openIn15s() {
        scheduleLaunch(after: 15, menuItem: fifteenSecItem)
    }

    func showMenu() {
        if let menu = menu {
            let mouseLocation = NSEvent.mouseLocation
            menu.popUp(positioning: nil, at: NSPoint(x: mouseLocation.x, y: mouseLocation.y), in: nil)
        }
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

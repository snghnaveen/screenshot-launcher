import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var menu: NSMenu?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "camera.fill", accessibilityDescription: "Screenshot")
            button.target = self
            button.action = #selector(leftClickAction)
        }

        // Create menu
        menu = NSMenu()
        menu?.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        // Track right-click events
        NSEvent.addLocalMonitorForEvents(matching: [.rightMouseUp]) { [weak self] event in
            guard let self = self else { return event }
            self.showMenu()
            return nil
        }
    }

    @objc func leftClickAction() {
        let path = "/System/Applications/Utilities/Screenshot.app"
        NSWorkspace.shared.open(URL(fileURLWithPath: path))
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

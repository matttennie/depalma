import AppKit
import TouchBarSupport

@MainActor
final class AppController: NSObject, NSApplicationDelegate {
    private let clickBlockController = ClickBlockController()

    private var currentState: ClickBlockController.State = .disabled

    private var statusItem: NSStatusItem?
    private var toggleMenuItem: NSMenuItem?
    private var statusMenuItem: NSMenuItem?

    private static let touchBarIdentifier = NSTouchBarItem.Identifier("com.matttennie.TouchGuard.controlstrip")
    private var touchBarItem: NSCustomTouchBarItem?
    private var touchBarButton: NSButton?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        setupMenuBar()
        setupTouchBar()
        setupCallbacks()
        render()
    }

    func applicationWillTerminate(_ notification: Notification) {
        clickBlockController.stop()
        removeTouchBar()
    }

    private func setupMenuBar() {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem = item

        let menu = NSMenu()

        let toggleItem = NSMenuItem(title: "", action: #selector(toggleClickGuard), keyEquivalent: "")
        toggleItem.target = self
        menu.addItem(toggleItem)
        toggleMenuItem = toggleItem

        let statusItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)
        statusMenuItem = statusItem

        menu.addItem(.separator())

        let permissionsItem = NSMenuItem(title: "Open Privacy Settings", action: #selector(openPrivacySettings), keyEquivalent: "")
        permissionsItem.target = self
        menu.addItem(permissionsItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit TouchGuard", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        item.menu = menu
    }

    private func setupTouchBar() {
        TouchBarShowCloseBoxWhenFrontMost(true)

        let item = NSCustomTouchBarItem(identifier: Self.touchBarIdentifier)
        let button = NSButton(title: "", target: self, action: #selector(toggleClickGuard))
        button.bezelStyle = .texturedRounded
        button.imagePosition = .imageOnly
        button.isBordered = false
        item.view = button

        touchBarItem = item
        touchBarButton = button

        TouchBarAddSystemTrayItem(item)
        TouchBarSetControlStripPresence(Self.touchBarIdentifier, true)
    }

    private func removeTouchBar() {
        guard let touchBarItem else { return }
        TouchBarSetControlStripPresence(Self.touchBarIdentifier, false)
        TouchBarRemoveSystemTrayItem(touchBarItem)
        self.touchBarItem = nil
        self.touchBarButton = nil
    }

    private func setupCallbacks() {
        clickBlockController.onStateChange = { [weak self] state in
            guard let self else { return }
            self.currentState = state
            self.render()
        }
    }

    private func render() {
        let presentation = ClickGuardPresenter.makePresentation(for: currentState)
        toggleMenuItem?.title = presentation.toggleTitle
        statusMenuItem?.title = presentation.statusLine

        let image = currentStateIcon(accessibilityDescription: presentation.statusLine)
        statusItem?.button?.image = image
        touchBarButton?.image = image
        touchBarButton?.toolTip = presentation.statusLine
    }

    private func currentStateIcon(accessibilityDescription: String) -> NSImage? {
        let fileName: String
        switch currentState {
        case .disabled:
            fileName = "trackpad_on"
        case .enabled:
            fileName = "trackpad_off"
        }

        if let url = Bundle.main.resourceURL?.appendingPathComponent("Icons/\(fileName).png"),
           let image = NSImage(contentsOf: url) {
            image.isTemplate = false
            return image
        }

        let fallback = NSImage(systemSymbolName: ClickGuardPresenter.makePresentation(for: currentState).symbolName, accessibilityDescription: accessibilityDescription)
        fallback?.isTemplate = true
        return fallback
    }

    @objc private func toggleClickGuard() {
        do {
            try clickBlockController.toggle(promptForPermissions: true)
        } catch {
            presentPermissionAlert(for: error)
        }
    }

    @objc private func openPrivacySettings() {
        PermissionController.openRelevantSettings()
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    private func presentPermissionAlert(for error: Error) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.messageText = "TouchGuard Needs Permission"
        alert.informativeText = [error.localizedDescription, (error as? LocalizedError)?.recoverySuggestion].compactMap { $0 }.joined(separator: "\n\n")
        alert.addButton(withTitle: "Open Settings")
        alert.addButton(withTitle: "Cancel")

        if alert.runModal() == .alertFirstButtonReturn {
            openPrivacySettings()
        }
    }
}

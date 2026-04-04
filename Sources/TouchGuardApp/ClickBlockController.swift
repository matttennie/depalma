import ApplicationServices
import Foundation

@MainActor
final class ClickBlockController {
    enum State: Equatable {
        case disabled
        case enabled(blockedClicks: UInt64)
    }

    var onStateChange: ((State) -> Void)?

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var blockedClicks: UInt64 = 0
    private(set) var isEnabled = false

    func start(promptForPermissions: Bool) throws {
        try PermissionController.validate(prompt: promptForPermissions)

        if eventTap == nil {
            try createTap()
        }

        blockedClicks = 0
        isEnabled = true
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: true)
        }
        publishState()
    }

    func stop() {
        isEnabled = false
        if let eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        publishState()
    }

    func toggle(promptForPermissions: Bool) throws {
        if isEnabled {
            stop()
        } else {
            try start(promptForPermissions: promptForPermissions)
        }
    }

    private func createTap() throws {
        let callback: CGEventTapCallBack = { _, type, event, refcon in
            let controller = Unmanaged<ClickBlockController>.fromOpaque(refcon!).takeUnretainedValue()
            return controller.handleEvent(type: type, event: event)
        }

        let tap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: ClickEventClassifier.eventMask,
            callback: callback,
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        guard let tap else {
            throw ClickBlockError.tapCreationFailed
        }

        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)

        eventTap = tap
        runLoopSource = source
    }

    private func handleEvent(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            if isEnabled, let eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: true)
            }
            return Unmanaged.passRetained(event)
        }

        guard isEnabled, ClickEventClassifier.shouldBlock(type) else {
            return Unmanaged.passRetained(event)
        }

        blockedClicks += 1
        publishState()
        return nil
    }

    private func publishState() {
        if isEnabled {
            onStateChange?(.enabled(blockedClicks: blockedClicks))
        } else {
            onStateChange?(.disabled)
        }
    }
}

enum ClickBlockError: LocalizedError {
    case tapCreationFailed

    var errorDescription: String? {
        switch self {
        case .tapCreationFailed:
            return "macOS did not allow TouchGuard to create a click-filter event tap."
        }
    }
}

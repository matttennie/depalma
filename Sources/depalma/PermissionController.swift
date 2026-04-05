import AppKit
import ApplicationServices

enum PermissionIssue: Error {
    case missingAccessibility
    case missingInputMonitoring
    case missingBoth
}

enum PermissionController {
    static func accessibilityGranted(prompt: Bool) -> Bool {
        let options = ["AXTrustedCheckOptionPrompt": prompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }

    static func inputMonitoringGranted(prompt: Bool) -> Bool {
        if prompt {
            return CGRequestListenEventAccess()
        }
        return CGPreflightListenEventAccess()
    }

    static func validate(prompt: Bool) throws {
        let accessibility = accessibilityGranted(prompt: prompt)
        let inputMonitoring = inputMonitoringGranted(prompt: prompt)

        switch (accessibility, inputMonitoring) {
        case (true, true):
            return
        case (false, false):
            throw PermissionIssue.missingBoth
        case (false, true):
            throw PermissionIssue.missingAccessibility
        case (true, false):
            throw PermissionIssue.missingInputMonitoring
        }
    }

    static func openRelevantSettings() {
        let urls = [
            "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility",
            "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent",
            "x-apple.systempreferences:com.apple.Settings.PrivacySecurity.extension",
        ]

        for candidate in urls {
            if let url = URL(string: candidate), NSWorkspace.shared.open(url) {
                return
            }
        }
    }
}

extension PermissionIssue: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingAccessibility:
            return "depalma needs Accessibility permission to filter click events."
        case .missingInputMonitoring:
            return "depalma needs Input Monitoring permission to observe the click stream."
        case .missingBoth:
            return "depalma needs both Accessibility and Input Monitoring permissions."
        }
    }

    var recoverySuggestion: String? {
        "Grant the requested permissions in System Settings, then relaunch depalma and toggle it on again."
    }
}

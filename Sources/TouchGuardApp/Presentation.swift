import Foundation

struct ClickGuardPresentation: Equatable {
    let toggleTitle: String
    let statusLine: String
    let symbolName: String
}

enum ClickGuardPresenter {
    static func makePresentation(for state: ClickBlockController.State) -> ClickGuardPresentation {
        switch state {
        case .disabled:
            return ClickGuardPresentation(
                toggleTitle: "Enable Click Guard",
                statusLine: "Click Guard off",
                symbolName: "hand.point.up.left.fill"
            )
        case .enabled(let blockedClicks):
            let suffix = blockedClicks == 0 ? "Click Guard on" : "Click Guard on; blocked \(blockedClicks) clicks"
            return ClickGuardPresentation(
                toggleTitle: "Disable Click Guard",
                statusLine: suffix,
                symbolName: "hand.raised.slash.fill"
            )
        }
    }
}

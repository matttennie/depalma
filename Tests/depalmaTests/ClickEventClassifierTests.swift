import ApplicationServices
import XCTest
@testable import depalma

final class ClickEventClassifierTests: XCTestCase {
    func testBlocksOnlyClickDownAndUpEvents() {
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.leftMouseDown))
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.leftMouseUp))
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.rightMouseDown))
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.rightMouseUp))
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.otherMouseDown))
        XCTAssertTrue(ClickEventClassifier.shouldBlock(.otherMouseUp))
    }

    func testDoesNotBlockKeyboardOrMovementEvents() {
        XCTAssertFalse(ClickEventClassifier.shouldBlock(.keyDown))
        XCTAssertFalse(ClickEventClassifier.shouldBlock(.keyUp))
        XCTAssertFalse(ClickEventClassifier.shouldBlock(.flagsChanged))
        XCTAssertFalse(ClickEventClassifier.shouldBlock(.mouseMoved))
        XCTAssertFalse(ClickEventClassifier.shouldBlock(.scrollWheel))
    }
}

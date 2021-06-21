    import XCTest
    @testable import Permit

    final class PermitTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
          XCTAssertEqual(Permissions().camera.rawValue, 0)
        }
    }

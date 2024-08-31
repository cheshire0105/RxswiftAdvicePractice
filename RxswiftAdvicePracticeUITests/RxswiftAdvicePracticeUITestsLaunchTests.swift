//
//  RxswiftAdvicePracticeUITestsLaunchTests.swift
//  RxswiftAdvicePracticeUITests
//
//  Created by cheshire on 8/24/24.
//

import XCTest

final class RxswiftAdvicePracticeUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // 앱이 실행된 후 특정 UI 요소가 나타나는지 확인
        let fetchButton = app.buttons["Fetch Advice"]
        XCTAssertTrue(fetchButton.exists, "Fetch Advice 버튼이 표시되지 않았습니다.")

        // 스크린샷을 캡처하여 테스트에 추가
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

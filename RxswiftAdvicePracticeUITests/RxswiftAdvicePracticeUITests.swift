//
//  RxswiftAdvicePracticeUITests.swift
//  RxswiftAdvicePracticeUITests
//
//  Created by cheshire on 8/24/24.
//

import XCTest

final class RxswiftAdvicePracticeUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments = ["-useMockAPI"]
        app.launch()
    }

    func testFetchAdvice() throws {
        let app = XCUIApplication()

        // Fetch Advice 버튼이 있는지 확인
        let fetchButton = app.buttons["Fetch Advice"]
        XCTAssertTrue(fetchButton.exists, "Fetch Advice 버튼이 존재하지 않습니다.")

        // Fetch Advice 버튼을 탭
        fetchButton.tap()

        // 로딩 인디케이터가 나타나는지 확인
        let activityIndicator = app.activityIndicators["activityIndicator"]
        XCTAssertTrue(activityIndicator.waitForExistence(timeout: 5), "로딩 인디케이터가 표시되지 않았습니다.")

        // 목업 데이터가 화면에 표시될 때까지 대기
        let messageLabel = app.staticTexts["Test Message"]
        XCTAssertTrue(messageLabel.waitForExistence(timeout: 10), "명언이 표시되지 않았습니다.")

        let authorLabel = app.staticTexts["Test Author"]
        XCTAssertTrue(authorLabel.waitForExistence(timeout: 10), "작가 이름이 표시되지 않았습니다.")

        let authorProfileLabel = app.staticTexts["Test Profile"]
        XCTAssertTrue(authorProfileLabel.waitForExistence(timeout: 10), "작가 프로필이 표시되지 않았습니다.")

        // 로딩 인디케이터가 사라졌는지 확인
        XCTAssertFalse(activityIndicator.exists, "로딩 인디케이터가 여전히 표시되고 있습니다.")
    }
}

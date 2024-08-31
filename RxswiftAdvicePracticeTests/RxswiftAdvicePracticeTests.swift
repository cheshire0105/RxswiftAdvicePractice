//
//  RxswiftAdvicePracticeTests.swift
//  RxswiftAdvicePracticeTests
//
//  Created by cheshire on 8/24/24.
//

import XCTest
import RxSwift
import RxCocoa
@testable import RxswiftAdvicePractice

// `AdviceViewModelTests` 클래스는 `AdviceViewModel`의 기능을 테스트합니다.
final class AdviceViewModelTests: XCTestCase {

    // 테스트할 ViewModel 인스턴스
    var viewModel: AdviceViewModel!
    // Mock API 서비스를 사용하여 실제 네트워크 호출을 모의(Mock)함
    var mockAPIService: MockAPIService!
    // RxSwift에서 사용하는 DisposeBag, Observable의 구독 해제에 사용됨
    var disposeBag: DisposeBag!

    // 각 테스트가 실행되기 전에 호출되는 메서드, 초기화 작업을 수행함
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIService = MockAPIService()  // Mock API 서비스 인스턴스 생성
        viewModel = AdviceViewModel(apiService: mockAPIService)  // Mock API 서비스를 주입하여 ViewModel 생성
        disposeBag = DisposeBag()  // DisposeBag 초기화
    }

    // 각 테스트가 종료된 후 호출되는 메서드, 정리 작업을 수행함
    override func tearDownWithError() throws {
        viewModel = nil  // ViewModel 인스턴스 해제
        mockAPIService = nil  // Mock API 서비스 인스턴스 해제
        disposeBag = nil  // DisposeBag 해제
        try super.tearDownWithError()
    }

    // `fetchAdvice()` 메서드가 성공적으로 명언을 가져오는지 테스트하는 메서드
    func testFetchAdviceSuccess() throws {
        // Given: 테스트를 위한 초기 상태 설정
        let expectedAdvice = Advice(author: "Test Author", authorProfile: "Test Profile", message: "Test Message")
        mockAPIService.adviceToReturn = expectedAdvice  // Mock API 서비스가 반환할 명언 설정

        // When: ViewModel에서 명언을 요청
        let expectation = XCTestExpectation(description: "Fetch advice successfully")  // 비동기 테스트를 위한 기대치 설정
        viewModel.advice
            .skip(1) // 초기값을 건너뛰고 이후의 값만 테스트
            .subscribe(onNext: { advice in
                // 명언의 각 항목이 예상한 값과 일치하는지 확인
                XCTAssertEqual(advice?.author, expectedAdvice.author)
                XCTAssertEqual(advice?.authorProfile, expectedAdvice.authorProfile)
                XCTAssertEqual(advice?.message, expectedAdvice.message)
                expectation.fulfill()  // 기대치 충족 시 테스트 성공
            })
            .disposed(by: disposeBag)  // 구독을 DisposeBag에 추가하여 메모리 관리

        viewModel.fetchAdvice()  // ViewModel에서 명언을 가져오는 메서드 호출

        // Then: 예상한 시간이 지나기 전에 기대치가 충족되었는지 확인
        wait(for: [expectation], timeout: 1.0)
    }

    // `fetchAdvice()` 메서드가 실패하는 경우를 테스트하는 메서드
    func testFetchAdviceFailure() throws {
        // Given: 테스트를 위한 초기 상태 설정
        mockAPIService.shouldReturnError = true  // Mock API 서비스가 에러를 반환하도록 설정

        // When: ViewModel에서 명언을 요청
        let expectation = XCTestExpectation(description: "Fetch advice failed with error")  // 비동기 테스트를 위한 기대치 설정
        viewModel.error
            .subscribe(onNext: { error in
                // 에러 메시지가 예상한 값과 일치하는지 확인
                XCTAssertEqual(error, "The operation couldn’t be completed. (TestError error -1.)")
                expectation.fulfill()  // 기대치 충족 시 테스트 성공
            })
            .disposed(by: disposeBag)  // 구독을 DisposeBag에 추가하여 메모리 관리

        viewModel.fetchAdvice()  // ViewModel에서 명언을 가져오는 메서드 호출

        // Then: 예상한 시간이 지나기 전에 기대치가 충족되었는지 확인
        wait(for: [expectation], timeout: 1.0)
    }
}

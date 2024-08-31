//
//  RxswiftAdvicePracticeTests.swift
//  RxswiftAdvicePracticeTests
//
//  Created by cheshire on 8/24/24.
//

import Foundation
import RxSwift

class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var adviceToReturn: Advice? = Advice(author: "Test Author", authorProfile: "Test Profile", message: "Test Message")

    func getAdvice() -> Observable<Advice> {
        if shouldReturnError {
            return Observable.error(NSError(domain: "TestError", code: -1, userInfo: nil))
        }

        if let advice = adviceToReturn {
            return Observable.just(advice)
        } else {
            return Observable.empty()
        }
    }
}

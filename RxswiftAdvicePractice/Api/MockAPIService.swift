//
//  MockAPIService.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/31/24.
//

import Foundation
import RxSwift

class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var adviceToReturn: Advice? = Advice(author: "Test Author", authorProfile: "Test Profile", message: "Test Message")
    var delayInSeconds: Int = 2  // 인위적인 지연을 추가하기 위한 속성

    func getAdvice() -> Observable<Advice> {
        if shouldReturnError {
            return Observable.error(NSError(domain: "TestError", code: -1, userInfo: nil))
        }

        if let advice = adviceToReturn {
            // 데이터를 반환하기 전에 인위적인 지연을 추가
            return Observable.just(advice)
                .delay(.seconds(delayInSeconds), scheduler: MainScheduler.instance)
        } else {
            return Observable.empty()
        }
    }
}

//
//  MockAPIService.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/24/24.
//

import Foundation
import RxSwift

class MockAPIService: APIServiceProtocol {
    var mockAdvice: Advice?
    var mockError: Error?

    func getAdvice() -> Observable<Advice> {
        if let error = mockError {
            return Observable.error(error)
        } else if let advice = mockAdvice {
            return Observable.just(advice)
        } else {
            return Observable.empty()
        }
    }
}

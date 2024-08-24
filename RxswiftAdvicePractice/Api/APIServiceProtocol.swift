//
//  APIServiceProtocol.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

protocol APIServiceProtocol {
    func getAdvice() -> Observable<Advice>
}

class APIService: APIServiceProtocol {
    func getAdvice() -> Observable<Advice> {
        let urlString = "https://korean-advice-open-api.vercel.app/api/advice"
        return RxAlamofire.requestData(.get, urlString)
            .map { response, data -> Advice in
                let decoder = JSONDecoder()
                return try decoder.decode(Advice.self, from: data)
            }
    }
}

// 사용한 API 주소 : https://github.com/gwongibeom/korean-advice-open-api

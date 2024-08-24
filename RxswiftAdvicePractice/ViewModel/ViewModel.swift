//
//  ViewModel.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/24/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

class AdviceViewModel {
    private let disposeBag = DisposeBag()
    private let apiService: APIServiceProtocol

    // Output
    let advice: BehaviorRelay<Advice?> = BehaviorRelay(value: nil)
    let error: PublishSubject<String> = PublishSubject()

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func fetchAdvice() {
        apiService.getAdvice()
            .subscribe(onNext: { [weak self] advice in
                self?.advice.accept(advice)
            }, onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}


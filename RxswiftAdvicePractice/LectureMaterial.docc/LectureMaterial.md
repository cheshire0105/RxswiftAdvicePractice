# RxSwift 입문 강의 자료

---

### 1. RxSwift란?

**RxSwift**는 iOS 앱 개발에서 **반응형 프로그래밍**을 가능하게 하는 라이브러리입니다. Rx라는 이름은 **Reactive Extensions**의 약자로, 데이터 스트림을 관찰하고 처리하는 방식을 통해 이벤트 기반의 비동기 프로그래밍을 단순화해줍니다.

#### 왜 RxSwift를 사용할까요?

1. **코드 간결화**: 복잡한 비동기 코드(네트워크 요청, UI 업데이트 등)를 보다 간단하게 표현할 수 있습니다.
2. **반응형 프로그래밍**: 사용자 입력, 네트워크 응답 등 다양한 이벤트를 하나의 스트림으로 관리하여 상태를 쉽게 처리할 수 있습니다.
3. **에러 처리의 일관성**: 네트워크 에러, 데이터 파싱 에러 등 모든 에러를 통합적으로 관리할 수 있습니다.

---

### 2. 데이터 스트림이란?

**데이터 스트림**은 시간이 지남에 따라 발생하는 데이터의 연속적인 흐름을 말합니다. RxSwift에서는 이러한 데이터 스트림을 통해 이벤트들을 관찰하고 처리합니다.

#### 예시:
- **UI 이벤트 스트림**: 버튼 클릭, 스크롤 이벤트 등
- **데이터 스트림**: 네트워크 응답, 사용자 입력 데이터 등

---

### 3. RxSwift를 사용한 데이터 흐름 예시

#### 3.1. APIService 구현

```swift
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
```

여기서 `getAdvice()` 메서드는 `Observable<Advice>`를 반환하여, API 요청 결과를 데이터 스트림으로 제공합니다.

#### 3.2. ViewModel 구현

```swift
import RxSwift
import RxCocoa

class AdviceViewModel {
    private let disposeBag = DisposeBag()
    private let apiService: APIServiceProtocol

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
```

ViewModel에서 데이터 스트림을 구독(subscribe)하여, API 호출 결과를 처리하고 UI에 반영할 수 있습니다.

---

### 4. RxSwift를 사용하지 않은 경우의 코드 비교

RxSwift를 사용하지 않는다면 다음과 같은 코드가 됩니다:

```swift
import Foundation

class NonReactiveAPIService {
    func getAdvice(completion: @escaping (Result<Advice, Error>) -> Void) {
        let urlString = "https://korean-advice-open-api.vercel.app/api/advice"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let advice = try JSONDecoder().decode(Advice.self, from: data)
                completion(.success(advice))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
```

여기서는 네트워크 요청의 결과를 콜백으로 처리하며, 에러 처리도 각각의 콜백 안에서 개별적으로 이루어집니다. 이 방식은 복잡한 흐름을 관리할 때 코드가 길어지고 복잡해질 수 있습니다.

---

### 5. RxSwift로 데이터를 처리하는 방식

RxSwift를 사용하면 네트워크 요청, UI 업데이트, 에러 처리를 모두 **데이터 스트림**으로 간단하게 관리할 수 있습니다.

#### 장점:
- **가독성 향상**: 이벤트 흐름을 단일 스트림으로 관리하므로 코드가 단순해집니다.
- **유연한 에러 처리**: 에러를 스트림 안에서 일관되게 처리할 수 있습니다.
- **비동기 작업의 간소화**: 복잡한 비동기 작업도 간단한 연산자(map, filter, combine 등)를 사용하여 쉽게 조작할 수 있습니다.

---

### 6. 결론

RxSwift는 반응형 프로그래밍을 통해 복잡한 비동기 이벤트를 간단하게 처리할 수 있는 강력한 도구입니다. 특히 네트워크 요청이나 UI 업데이트 같은 비동기 작업에서 그 진가를 발휘하며, 코드를 간결하고 유지보수하기 쉽게 만들어줍니다. 이 강의를 통해 RxSwift의 기본 개념과 사용법을 이해하고, 실무에서 RxSwift를 적극적으로 활용할 수 있는 발판을 마련하시길 바랍니다.

--- 


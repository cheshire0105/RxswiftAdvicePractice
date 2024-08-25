# Understanding RxSwift and MVVM patterns

### RxSwift와 MVVM 패턴의 이해

RxSwift는 리액티브 프로그래밍 라이브러리로, 비동기 작업을 쉽게 처리하고 데이터 흐름을 관리할 수 있도록 도와줍니다. 이를 통해 UI와 비즈니스 로직을 효과적으로 분리할 수 있습니다. MVVM(Model-View-ViewModel) 패턴은 UI와 로직을 분리하여 유지보수성과 테스트 용이성을 높이는 아키텍처 패턴입니다.

여기서 RxSwift와 MVVM 패턴을 사용하여 명언을 가져와서 UI에 표시하는 앱을 작성했습니다. 아래에서 이 코드가 어떻게 작동하는지, 그리고 RxSwift와 MVVM의 개념을 쉽게 설명하겠습니다.

### 1. RxSwift의 주요 개념

RxSwift는 데이터 스트림을 다루는 데 사용됩니다. 여기서 몇 가지 중요한 개념이 있습니다:

- **Observable**: 데이터 스트림을 나타내며, 이벤트를 방출(emit)합니다. 예를 들어, 네트워크 요청의 결과, 사용자 입력 등을 Observable로 다룰 수 있습니다.
- **Observer**: Observable이 방출한 이벤트를 구독(subscribe)하여 처리합니다.
- **DisposeBag**: 구독을 관리하며, 메모리 누수를 방지하기 위해 사용됩니다.
- **Operators**: Observable을 변환하거나 필터링하는 등의 작업을 수행하는 메서드들입니다. 예를 들어 `map`, `filter`, `flatMap` 등이 있습니다.

### 2. 코드 설명

#### 2.1. APIService

```swift
import RxAlamofire
import RxSwift

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

- **`APIService`**: 이 클래스는 네트워크 요청을 관리합니다. `getAdvice()` 메서드는 RxAlamofire를 사용하여 HTTP GET 요청을 보내고, 서버에서 받은 JSON 데이터를 `Advice` 구조체로 변환하여 Observable로 반환합니다.

- **Observable**: `getAdvice()`는 Observable을 반환하므로, ViewModel에서 이 스트림을 구독하여 데이터를 받을 수 있습니다.

#### 2.2. ViewModel

```swift
import RxSwift
import RxCocoa

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
```

- **`AdviceViewModel`**: 이 클래스는 비즈니스 로직을 담당하며, View와 데이터를 연결합니다. 
- **`BehaviorRelay`**: 초기값을 가지며, 상태를 지속적으로 업데이트할 수 있는 스트림입니다. UI에서 이 값을 구독하여 상태 변화에 따라 UI를 업데이트합니다.
- **`PublishSubject`**: 구독 시점부터 데이터를 방출하며, 주로 에러 처리나 단발성 이벤트를 처리할 때 사용합니다.
- **`fetchAdvice()`**: 네트워크 요청을 시작하고, 성공 시 데이터를 `advice`에, 실패 시 에러 메시지를 `error`에 전달합니다.

#### 2.3. ViewController

```swift
import RxSwift
import RxCocoa
import SnapKit

class AdviceViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: AdviceViewModel

    init(viewModel: AdviceViewModel = AdviceViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func bindViewModel() {
        let isLoading = BehaviorRelay<Bool>(value: false)

        isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.advice
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in
                isLoading.accept(false)
            }, onSubscribe: {
                isLoading.accept(true)
            })
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] advice in
                self?.messageLabel.text = advice.message
                self?.authorLabel.text = advice.author
                self?.authorProfileLabel.text = advice.authorProfile
            })
            .disposed(by: disposeBag)

        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { error in
                print("Error: \(error)")
                isLoading.accept(false)
            })
            .disposed(by: disposeBag)

        fetchButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.fetchAdvice()
            }
            .disposed(by: disposeBag)
    }
}
```

- **`AdviceViewController`**: UI와 ViewModel을 연결하는 역할을 합니다.
- **`bindViewModel()`**: ViewModel의 데이터를 UI에 바인딩합니다. 버튼 클릭, 데이터 로딩, 에러 처리가 모두 여기에 정의되어 있습니다.
- **RxCocoa**: RxSwift와 Cocoa Touch 프레임워크 간의 브릿지 역할을 하여, UI 요소와 반응형 프로그래밍을 쉽게 연결해줍니다. 여기서는 `fetchButton.rx.tap`을 사용하여 버튼 클릭 이벤트를 구독합니다.

### 3. MVVM 패턴에서의 역할

- **Model**: 데이터의 구조와 로직을 정의합니다. 여기서는 `Advice` 구조체가 모델에 해당합니다.
- **View**: 사용자 인터페이스를 담당하며, 여기서는 `AdviceViewController`가 View 역할을 합니다.
- **ViewModel**: 데이터와 UI를 연결하며, UI의 상태를 관리합니다. 여기서는 `AdviceViewModel`이 해당합니다. 이 ViewModel은 Model에서 데이터를 받아 가공하고, View에 전달합니다.

### 4. RxSwift와 MVVM의 결합

RxSwift는 MVVM 패턴에서 View와 ViewModel 간의 데이터 흐름을 효율적으로 관리할 수 있게 해줍니다. Observable을 사용하여 데이터를 바인딩하고, ViewModel의 상태가 변경될 때마다 UI를 자동으로 업데이트할 수 있습니다. 이를 통해 코드의 결합도를 낮추고, 테스트 가능한 코드를 작성할 수 있습니다.

### 요약
이 코드에서는 RxSwift를 사용하여 네트워크 요청을 비동기적으로 처리하고, MVVM 패턴을 통해 View와 ViewModel을 분리하였습니다. 이로 인해 코드가 깔끔하고 유지보수하기 쉬워지며, UI와 비즈니스 로직이 분리되어 재사용성과 테스트 용이성이 높아졌습니다.

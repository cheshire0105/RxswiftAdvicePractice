### RxswiftAdvicePractice

## 개요

**RxswiftAdvicePractice**는 RxSwift를 사용한 리액티브 프로그래밍을 학습하기 위한 iOS 애플리케이션입니다. 이 앱은 API를 통해 랜덤한 조언(advice)을 가져와 화면에 표시하는 간단한 기능을 제공합니다.

## 주요 기능

- **리액티브 프로그래밍**: 비동기 데이터 스트림을 관리하기 위해 RxSwift를 사용합니다.
- **MVVM 아키텍처**: 명확한 역할 분리를 위해 Model-View-ViewModel 패턴을 구현했습니다.
- **단위 테스트**: ViewModel의 로직이 정확한지 확인하기 위한 단위 테스트를 포함하고 있습니다.
- **UI 테스트**: XCUI 테스트를 사용하여 UI 기능을 검증합니다.

## 설치 방법

1. 리포지토리 클론:
   ```bash
   git clone https://github.com/cheshire0105/RxswiftAdvicePractice.git
   ```
2. 프로젝트 디렉터리로 이동:
   ```bash
   cd RxswiftAdvicePractice
   ```
3. CocoaPods를 사용하여 의존성 설치:
   ```bash
   pod install
   ```
4. Xcode에서 프로젝트 열기:
   ```bash
   open RxswiftAdvicePractice.xcworkspace
   ```

## 사용 방법

- Xcode에서 프로젝트를 빌드하고 실행하세요.
- "Fetch Advice" 버튼을 클릭하면 랜덤 조언이 표시됩니다.
- 테스트를 위해 `-useMockAPI` 인수를 사용하여 목업 데이터를 사용하는 앱으로 전환할 수 있습니다.

## 테스트

### 단위 테스트
`RxswiftAdvicePracticeTests` 타겟을 선택한 후 `Cmd+U`를 눌러 단위 테스트를 실행할 수 있습니다.

### UI 테스트
`RxswiftAdvicePracticeUITests` 타겟을 선택한 후 `Cmd+U`를 눌러 UI 테스트를 실행할 수 있습니다.

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

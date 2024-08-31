//
//  SceneDelegate.swift
//  RxswiftAdvicePractice
//
//  Created by cheshire on 8/24/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene이 전달되었는지 확인합니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Mock API 사용 여부를 결정합니다.
        let useMockAPI = ProcessInfo.processInfo.arguments.contains("-useMockAPI")
        let apiService: APIServiceProtocol = useMockAPI ? MockAPIService() : APIService()

        // ViewModel을 생성하고, ViewController에 주입합니다.
        let adviceViewModel = AdviceViewModel(apiService: apiService)
        let adviceViewController = AdviceViewController(viewModel: adviceViewModel)

        // UIWindow를 생성하고 윈도우 씬을 연결합니다.
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = adviceViewController

        // 윈도우를 보이도록 설정합니다.
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // 씬이 시스템에 의해 해제될 때 호출됩니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 씬이 비활성 상태에서 활성 상태로 전환될 때 호출됩니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 씬이 활성 상태에서 비활성 상태로 전환되기 직전에 호출됩니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 씬이 백그라운드에서 포어그라운드로 전환될 때 호출됩니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 씬이 포어그라운드에서 백그라운드로 전환될 때 호출됩니다.
    }
}

//
//  SceneDelegate.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // UIWindow 생성
        window = UIWindow(windowScene: windowScene)
        
        // 로그인 상태에 따라 초기 뷰 컨트롤러 결정
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if isLoggedIn {
            // 로그인 되어 있으면 탭 바 컨트롤러를 루트로 설정
            setupTabBarController()
        } else {
            // 로그인 되어 있지 않으면 로그인 뷰 컨트롤러를 루트로 설정
            let loginViewController = LogInViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
    }

    func setupTabBarController() {
        let tabBarController = UITabBarController()
        
        // 첫 번째 탭: 메인 뷰 컨트롤러
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        // 두 번째 탭: 검색 뷰 컨트롤러
        let searchVC = MovieViewController()
        searchVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        // 세 번째 탭: 프로필 뷰 컨트롤러
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "MY", image: UIImage(systemName: "person.fill"), tag: 2)
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: mainVC), UINavigationController(rootViewController: searchVC), UINavigationController(rootViewController: profileVC)]
        tabBarController.selectedIndex = 0 // 기본 선택 탭 설정 (예: 홈 화면)
        
        // 탭 바 모양 설정
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(red: 0.075, green: 0.412, blue: 0.4, alpha: 1)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.kOlive
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.kOlive]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }

        window?.rootViewController = PaymentCompletedViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}


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
        
        // 사용자 정보를 확인
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            // 사용자 ID를 찾았을 때의 처리
            print("User ID found:", userID)
        } else {
            // 사용자 ID가 없을 때의 처리
            print("No user ID found in UserDefaults")
        }
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        
//        let loginViewController = ProfileViewController()
//        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        // 탭 바 컨트롤러 생성
        let tabBarController = UITabBarController()
        
        // 첫 번째 탭
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "person.fill"), tag: 0)
        mainVC.view.backgroundColor = .white
        tabBarController.viewControllers = [UINavigationController(rootViewController: mainVC)]
        
        // 두 번째 탭
        let searchVC = ProfileViewController()
        searchVC.view.backgroundColor = .white
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        // 세 번째 탭
        let ticketVC = ExMovieViewController()
        ticketVC.view.backgroundColor = .white
        ticketVC.tabBarItem = UITabBarItem(title: "Ticket", image: UIImage(systemName: "bell.fill"), tag: 2)
        
        // 네 번째 탭
        let profileVC = LogInViewController()
        profileVC.view.backgroundColor = .white
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "gear"), tag: 3)
        
        // 탭 바 컨트롤러에 뷰 컨트롤러 추가
        tabBarController.viewControllers = [mainVC, searchVC, ticketVC, profileVC]
        
        // 탭 바 모양
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(red: 0.075, green: 0.412, blue: 0.4, alpha: 1)
                
        // 선택되지 않은 탭 색상
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        // 선택 탭 색상
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // 모든 탭 바 인스턴스에 적용
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
        
        window = UIWindow(windowScene: windowScene)
//        window?.rootViewController = LogInViewController() // 원하는 뷰컨트롤러로 변경해주기
         window?.rootViewController = BookingMovieViewController()
//        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
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


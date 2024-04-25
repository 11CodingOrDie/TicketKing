//
//  MainTabBarViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/25/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabbar()
        
        tabBar.barTintColor = .kDarkGreen
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .kOlive
        
        
        // 네비게이션 바 숨김
        navigationController?.isNavigationBarHidden = true
        
    }
    
    //탭바 세팅
    func setTabbar() {
        let home = createNavController(title: "홈",image: UIImage(systemName: "house.fill"), vc: MainViewController())
        let search = createNavController(title: "검색",image: UIImage(systemName: "magnifyingglass"), vc: MovieViewController())
        let ticket = createNavController(title: "예매",image: UIImage(systemName: "ticket"), vc: MovieViewController())
        let mypage = createNavController(title: "MY",image: UIImage(systemName: "person.fill"), vc: MainViewController())
        
        // Set the view controllers for the tab bar controller
        setViewControllers([home, search, ticket, mypage], animated: true)
        }
    
    
    // UINavigationController 생성 함수
    func createNavController(title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}

//
//  TabBarView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        setupTabs()
        
        self.tabBar.backgroundColor = .systemGray4
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .gray
    }
    
    private func setupTabs() {
        let gamePage = self.createNav(with: "game", and: UIImage(systemName: "gamecontroller"), viewController: GamePageVC())
        let accountPage = self.createNav(with: "account", and: UIImage(systemName: "person"), viewController: AccountPageVC())
        
        self.setViewControllers([gamePage,accountPage], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }
}

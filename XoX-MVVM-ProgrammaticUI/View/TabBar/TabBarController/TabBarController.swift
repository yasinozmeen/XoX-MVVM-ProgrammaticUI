//
//  TabBarView.swift
//  XoX-MVVM-ProgrammaticUI
//
//  Created by Kadir Yasin Özmen on 2.06.2023.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {
    
// MARK: - Properties
    typealias constant = ConstantsTabBar
    
// MARK: - Life Cycle
    override func viewDidLoad() {
        setupTabs()
        self.tabBar.backgroundColor = .systemGray4
        self.tabBar.tintColor = .label
        self.tabBar.unselectedItemTintColor = .gray
    }
    
// MARK: - Functions
    private func setupTabs() {
        let gamePage = self.createNav(with: constant.game.rawValue, and: UIImage(systemName: constant.gameImage.rawValue), viewController: GamePageVC())
        let accountPage = self.createNav(with: constant.account.rawValue, and: UIImage(systemName: constant.accountImage.rawValue), viewController: AccountPageVC())
        self.setViewControllers([gamePage,accountPage], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
    
    
}

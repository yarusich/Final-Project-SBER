//
//  FinalTabBarController.swift
//  FinalProject
//
//  Created by Антон Сафронов on 26.07.2021.
//

import UIKit

class FinalTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    private func setupController() {
        let item1 = UITabBarItem.init(tabBarSystemItem: .search, tag: 1)
        let item2 = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        let item3 = UITabBarItem.init(tabBarSystemItem: .downloads, tag: 1)
        
        let networkService = NetworkService()
        
        let mainViewController = UINavigationController(rootViewController: MainViewController(networkService: networkService))
        mainViewController.tabBarItem = item1
        
        let favoriteViewController = UINavigationController(rootViewController: FavoriteViewController())
        favoriteViewController.tabBarItem = item2
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = item3
        
        viewControllers = [mainViewController, favoriteViewController, profileViewController]
    }
}



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
        let mainScreen = UITabBarItem.init(tabBarSystemItem: .search, tag: 1)
        let favoriteScreen = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        let profileScreen = UITabBarItem.init(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 1)
        
        let networkService = NetworkService()
        
        let mainViewController = UINavigationController(rootViewController: MainViewController(networkService: networkService))
        mainViewController.tabBarItem = mainScreen
        
        let favoriteViewController = UINavigationController(rootViewController: FavoriteViewController())
        favoriteViewController.tabBarItem = favoriteScreen
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = profileScreen
        
        viewControllers = [mainViewController, favoriteViewController, profileViewController]
    }
}



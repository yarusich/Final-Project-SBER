//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Антон Сафронов on 27.06.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        MARK: Вынести отсюда
        
        
        let item1 = UITabBarItem.init(tabBarSystemItem: .search, tag: 1)
        let item2 = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        let item3 = UITabBarItem.init(tabBarSystemItem: .downloads, tag: 1)
        
        let rootVC = FavoriteViewController()
        let networkService = NetworkService()
//        let rootVC = MainViewController(networkService: networkService)
        
        let tabBarController = UITabBarController()
        
        let mainViewController = MainViewController(networkService: networkService)
        var favoriteViewController = FavoriteViewController()
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        navigationController.tabBarItem = item1
        favoriteViewController.tabBarItem = item2
        profileViewController.tabBarItem = item3
        tabBarController.viewControllers = [navigationController, favoriteViewController, profileViewController]
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        if let statusBarFrame = window?.windowScene?.statusBarManager?.statusBarFrame {
            DConstants.statusBarHeight = statusBarFrame.height
            let statusBarBackgroundView = UIView(frame: statusBarFrame)
            window?.addSubview(statusBarBackgroundView)
            statusBarBackgroundView.backgroundColor = .red
        }

        
        
        return true
    }

//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "FinalProject")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
//
}


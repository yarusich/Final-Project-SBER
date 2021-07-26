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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = FinalTabBarController()
        window?.makeKeyAndVisible()

        return true
    }
}


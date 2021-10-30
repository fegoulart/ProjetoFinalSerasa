//
//  AppDelegate.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewController: UIViewController = HomeViewController( )
        let navigationController =  UINavigationController(rootViewController: viewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController =  navigationController
        self.window?.makeKeyAndVisible()

        print("Tamanho: \(UIScreen.main.bounds)")

        return true
    }

}

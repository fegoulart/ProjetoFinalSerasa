//
//  AppDelegate.swift
//  CatAPI
//
//  Created by Thayanne Viana on 21/10/21.
//

import UIKit
import CoreData
import CatLoader

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController =  setupTabBar()
        self.window?.makeKeyAndVisible()

        print("Tamanho: \(UIScreen.main.bounds)")

        return true
    }

    private func setupTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray
        tabBarController.tabBar.barTintColor = .systemGray
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.viewControllers = setupViewControllers()
        return tabBarController
    }

    private func setupViewControllers() -> [UIViewController] {
        return [mainViewController(), favoritesViewController()]
    }

    private func mainViewController() -> UIViewController {
        let mCatLoader = CatLoader()
        let viewController = HomeViewController(catLoader: mCatLoader)
        let navigationController =  UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = tabBarItem(title: "home", systemIcon: "house")
        return navigationController
    }

    private func favoritesViewController() -> UIViewController {
        let localRepository = CoreDataRepository()
        let viewController = FavoritesViewController(localRepository: localRepository)
        viewController.tabBarItem = tabBarItem(title: "favorites", systemIcon: "star")
        let navigationController =  UINavigationController(rootViewController: viewController)
        return navigationController
    }

    private func tabBarItem(title: String, systemIcon: String) -> UITabBarItem {
        let tabBarImage = UIImage(systemName: systemIcon)
        return UITabBarItem(title: title, image: tabBarImage, selectedImage: tabBarImage)
    }
}

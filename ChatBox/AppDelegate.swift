//
//  AppDelegate.swift
//  ChatBox
//
//  Created by Alexey Teplonogov on 22/09/2018.
//  Copyright © 2018 Alexey Teplonogov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let themeService = ThemeService.shared

        let conversationsListVC = rootAssembly.presentationAssembly.createConversationsListController()

        let navigationController = UINavigationController()
        navigationController.viewControllers = [conversationsListVC]

        navigationController.navigationBar.prefersLargeTitles = true

        if let themeData = UserDefaults.standard.object(forKey: "theme") as? Data {
            let color = NSKeyedUnarchiver.unarchiveObject(with: themeData) as? UIColor
            themeService.changeThemeTo(color: color!)
        } else {
            ThemeService.shared.changeThemeTo(color: UIColor.white)
        }

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

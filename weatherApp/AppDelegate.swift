//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        AppRouter.shared.window = window
        AppRouter.shared.showInitialModule()
        return true
    }
}

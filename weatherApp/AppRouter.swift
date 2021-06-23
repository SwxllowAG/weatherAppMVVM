//
//  AppRouter.swift
//  weatherApp
//
//  Created by Galym Anuarbek on 23.06.2021.
//

import UIKit

class AppRouter {
    // MARK: - Singleton
    
    static var shared: AppRouter = AppRouter()
    
    // MARK: - Public properties
    
    var window: UIWindow?
    
    // MARK: - initializers
    
    init() {
        
    }
    
    
    // MARK: - Public functions
    func setupNewWindow(window: UIWindow) {
        self.window = window
    }
    
    func showInitialModule() {
        let module = SearchCityModuleAssembler()
        self.window?.rootViewController = UINavigationController(rootViewController: module.vc)
        self.window?.makeKeyAndVisible()
    }
}

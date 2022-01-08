//
//  AppCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 06/01/22.
//

import Foundation
import GGDevelopmentKit

class AppCoordinator: GGBaseCoordinator<UIViewController> {
    
    private let window: UIWindow
    private let tabBarCoordinator: TabBarCoordinator
    
    init(window: UIWindow) {
        self.window = window
        tabBarCoordinator = TabBarCoordinator()
        window.rootViewController = tabBarCoordinator.tabBarController
        super.init(rootViewController: window.rootViewController)
    }
    
    override func start() {
        
        tabBarCoordinator.start()
    }
}

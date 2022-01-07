//
//  TabBarCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 06/01/22.
//

import Foundation
import GGDevelopmentKit

fileprivate enum TabBarItem: String {
    case Pokedex
    case Favorites
}

class TabBarCoordinator: GGBaseCoordinator<UITabBarController> {
    let tabBarController: UITabBarController
    
    init() {
        tabBarController = UITabBarController()
        super.init(rootViewController: tabBarController)
        
    }
       
    override func start() {
        let listCoordinator = PokemonListCoordinator()
        let listTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "PokeDexIcon"), selectedImage: #imageLiteral(resourceName: "PokeDexIcon"))
        listTabBarItem.tag = 0
        listCoordinator.rootViewController.tabBarItem = listTabBarItem
        listCoordinator.start()

        tabBarController.setViewControllers([listCoordinator.rootViewController],
                                             animated: true)
    }
}


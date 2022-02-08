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
        
        //List All
        let service = PokemonListAllService()
        let interactor = PokemonListAllInteractor(service: service)
        let viewModel = PokemonListAllViewModel(interactor: interactor)
        let listViewController = PokemonListViewController(viewModel: viewModel)
        
        let listCoordinator = PokemonListCoordinator(listViewController: listViewController, viewModel: viewModel)
        let listTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "PokeDexIcon"), selectedImage: #imageLiteral(resourceName: "PokeDexIcon"))
        listTabBarItem.tag = 0
        listCoordinator.rootViewController.tabBarItem = listTabBarItem
        listCoordinator.start()
        
        //List Favorites
        let listFavinteractor = PokemonListFavoritesInteractor()
        let listFaviViewModel = PokemonListFavoritesViewModel(interactor: listFavinteractor)
        let listFavViewController = PokemonListViewController(viewModel: listFaviViewModel)
        
        let listFavCoordinator = PokemonListCoordinator(listViewController: listFavViewController, viewModel: listFaviViewModel)
        let listFavTabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "PokeballIcon"), selectedImage: #imageLiteral(resourceName: "PokeballIcon"))
        listFavTabBarItem.tag = 1
        listFavCoordinator.rootViewController.tabBarItem = listFavTabBarItem
        listFavCoordinator.start()

        tabBarController.setViewControllers([listCoordinator.rootViewController,
                                             listFavCoordinator.rootViewController],
                                             animated: true)
    }
}


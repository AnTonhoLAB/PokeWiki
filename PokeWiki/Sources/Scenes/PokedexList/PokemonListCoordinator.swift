//
//  PokemonListCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 06/01/22.
//

import Foundation
import GGDevelopmentKit

class PokemonListCoordinator: GGCoordinator {
    
    init() {
        super.init(rootViewController: UINavigationController())
    }

    override func start() {
        let listViewController = ViewController()
        self.show(listViewController)
    }
}

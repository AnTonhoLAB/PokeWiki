//
//  PokemonDetailCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import GGDevelopmentKit

class PokemonDetailCoordinator: GGCoordinator {
    
    private let PokemonItem: PokemonItem
    
    init(navigation: UINavigationController, pokemonDetail: PokemonItem) {
        self.PokemonItem = pokemonDetail
        super.init(rootViewController: navigation)
    }

    override func start() {
        let interactor = PokemonDetailInteractor()
        let viewModel = PokemonDetailViewModel(interactor: interactor, pokemonDetail: PokemonItem)
        let detailViewController = PokemonDetailViewController(viewModel: viewModel)
        
        show(detailViewController)
    }
}

//
//  PokemonDetailCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import GGDevelopmentKit

class PokemonDetailCoordinator: GGCoordinator {
    
    private let pokemonItem: PokemonItem
    
    init(navigation: UINavigationController, pokemonDetail: PokemonItem) {
        self.pokemonItem = pokemonDetail
        super.init(rootViewController: navigation)
    }

    override func start() {
        let service = PokemonDetailService()
        let interactor = PokemonDetailInteractor(service: service)
        let viewModel = PokemonFullDetailViewModel(name: pokemonItem.name, url: pokemonItem.url, interactor: interactor)
        let detailViewController = PokemonDetailViewController(viewModel: viewModel)
        
        present(detailViewController)
    }
}

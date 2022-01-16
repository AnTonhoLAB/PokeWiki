//
//  PokemonDetailCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import GGDevelopmentKit

class PokemonDetailCoordinator: GGCoordinator {
    
    private let pokemonDetail: PokemonDetail
    private let image: UIImage
    
    init(navigation: UINavigationController, pokemonDetail: PokemonDetail, image: UIImage) {
        self.pokemonDetail = pokemonDetail
        self.image = image
        super.init(rootViewController: navigation)
    }

    override func start() {
        let interactor = PokemonDetailInteractor()
        let viewModel = PokemonDetailViewModel(interactor: interactor, pokemonDetail: pokemonDetail, image: image)
        let listViewController = PokemonDetailViewController(viewModel: viewModel)
        
        show(listViewController)
    }
}

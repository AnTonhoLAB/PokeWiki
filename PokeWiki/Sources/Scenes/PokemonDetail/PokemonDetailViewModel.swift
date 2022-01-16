//
//  PokemonDetailViewModel.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import GGDevelopmentKit

protocol  PokemonDetailViewModelProtocol {
    
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    
    
    private let interactor: PokemonDetailInteractorProtocol
    private let pokemonDetail: PokemonDetail
    private let image: UIImage
    
    init( interactor: PokemonDetailInteractorProtocol, pokemonDetail: PokemonDetail, image: UIImage) {
        self.interactor = interactor
        self.pokemonDetail = pokemonDetail
        self.image = image
    }
}

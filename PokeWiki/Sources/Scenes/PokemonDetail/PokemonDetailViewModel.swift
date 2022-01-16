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
    private let pokemonDetail: PokemonItem
    
    init( interactor: PokemonDetailInteractorProtocol, pokemonDetail: PokemonItem) {
        self.interactor = interactor
        self.pokemonDetail = pokemonDetail
    }
}

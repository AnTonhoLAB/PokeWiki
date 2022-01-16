//
//  PokemonDetailService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonDetailServiceProtocol {
    func fetchAPokemon(with name: String) -> Single<PokemonDetail>
    func fechPokemonImage(for id: Int) -> Single<Data>
}

final class PokemonDetailService: PokemonDetailServiceProtocol, RequesterProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    private let baseImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    private let png = ".png"
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        return Single<PokemonDetail>
            .create { [weak self, baseURL] single in
                self?.makeRequest(url: baseURL + name, single: single)
                return Disposables.create()
            }
    }
    
    func fechPokemonImage(for id: Int) -> Single<Data> {
        return Single<Data>
            .create { [weak self, baseImageURL, png] single in
                let url = baseImageURL + "\(id)" + png
                self?.makeRequestForImage(url: url, single: single)
                return Disposables.create()
            }
    }
}

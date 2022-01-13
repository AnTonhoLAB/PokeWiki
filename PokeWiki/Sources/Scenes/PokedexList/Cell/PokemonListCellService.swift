//
//  PokemonListCellService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonListCellServiceProtocol {
    func fetchAPokemon(with name: String) -> Single<PokemonDetail>
    func fechPokemonImage(for id: Int) -> Single<Data>
}

final class PokemonListCellService: PokemonListCellServiceProtocol, RequesterProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    private let baseImageURL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    private let png = ".png"
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        return Single<PokemonDetail>
            .create { [weak self] single in
                
                guard let self = self else {
                    single(.failure(PokemonListError.internalError))
                    return Disposables.create()
                }
                
                self.makeRequest(url: self.baseURL + name, single: single)
                return Disposables.create()
            }
    }
    
    func fechPokemonImage(for id: Int) -> Single<Data> {
        return Single<Data>
            .create { [weak self] single in
                
                guard let self = self else {
                    single(.failure(PokemonListError.internalError))
                    return Disposables.create()
                }
                let url = self.baseImageURL + "\(id)" + self.png
                self.makeRequestForImage(url: url, single: single)
                return Disposables.create()
            }
    }
}

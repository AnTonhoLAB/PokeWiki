//
//  PokemonListCellService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonListCellServiceProtocol {
    func fetchAPockemon(with name: String) -> Single<PokemonDetail>
}

final class PokemonListCellService: PokemonListCellServiceProtocol, RequesterProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    
    func fetchAPockemon(with name: String) -> Single<PokemonDetail> {
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
}

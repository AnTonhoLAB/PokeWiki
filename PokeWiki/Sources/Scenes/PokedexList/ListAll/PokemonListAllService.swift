//
//  PokemonListService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift

protocol PokemonListAllServiceProtocol {
    func fetchAll() -> Single<PokemonListResponse>
}

final class PokemonListAllService: PokemonListAllServiceProtocol, RequesterProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
    
    func fetchAll() -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { [weak self] single in
            
                guard let self = self else {
                    single(.failure(PokemonListError.internalError))
                    return Disposables.create()
                }
                
                self.makeRequest(url: self.baseURL, single: single)
                return Disposables.create()
            }
    }
}

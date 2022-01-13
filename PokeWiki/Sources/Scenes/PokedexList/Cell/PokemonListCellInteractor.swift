//
//  PokemonListCellInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonListCellInteractorProtocol {
    func fetchAPokemon(with name: String) -> Single<PokemonDetail>
    func fetchPokemonImage(for id: Int) -> Single<Data>
}

class PokemonListCellInteractor: PokemonListCellInteractorProtocol {
    
    let service: PokemonListCellServiceProtocol
    let networkingManager: NetworkingManagerProtocol
    
    init(service: PokemonListCellServiceProtocol, networkingManager: NetworkingManagerProtocol = NetworkingManager()) {
        self.service = service
        self.networkingManager = networkingManager
    }
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        guard networkingManager.isConnected  else {
            return Single<PokemonDetail>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        return service.fetchAPokemon(with: name)
    }
    
    func fetchPokemonImage(for id: Int) -> Single<Data> {
        guard networkingManager.isConnected  else {
            return Single<Data>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        return service.fechPokemonImage(for: id)
    }
}

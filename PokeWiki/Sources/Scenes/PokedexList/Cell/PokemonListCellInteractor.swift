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
    
    init(service: PokemonListCellService) {
        self.service = service
    }
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        if NetworkingManager.isConnected  {
            return service.fetchAPokemon(with: name)
        } else {
            return Single<PokemonDetail>
                .create { single in
                    single(.failure(PokemonListError.NoConnection))
                    return Disposables.create()
                }
        }
    }
    
    func fetchPokemonImage(for id: Int) -> Single<Data> {
        if NetworkingManager.isConnected  {
            return service.fechPokemonImage(for: id)
        } else {
            return Single<Data>
                .create { single in
                    single(.failure(PokemonListError.NoConnection))
                    return Disposables.create()
                }
        }
    }
}

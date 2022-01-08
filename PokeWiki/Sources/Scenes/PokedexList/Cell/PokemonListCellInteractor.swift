//
//  PokemonListCellInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonListCellInteractorProtocol {
    func fetchAPockemon(with name: String) -> Single<PokemonDetail>
}

class PokemonListCellInteractor: PokemonListCellInteractorProtocol {
    
    let service: PokemonListCellServiceProtocol
    
    init(service: PokemonListCellService) {
        self.service = service
    }
    
    func fetchAPockemon(with name: String) -> Single<PokemonDetail> {
        if NetworkingManager.isConnected  {
            return service.fetchAPockemon(with: name)
        } else {
            return Single<PokemonDetail>
                .create { single in
                    single(.failure(PokemonListError.NoConnection))
                    return Disposables.create()
                }
        }
    }
}

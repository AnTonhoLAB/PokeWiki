//
//  PokemonListAllInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift

protocol PokemonListAllInteractorProtocol {
    func fetchAll() -> Single<PokemonListResponse>
}

class PokemonListAllInteractor: PokemonListAllInteractorProtocol {
    
    let service: PokemonListAllServiceProtocol
    
    init(service: PokemonListAllServiceProtocol) {
        self.service = service
    }
    
    func fetchAll() -> Single<PokemonListResponse> {
        if NetworkingManager.isConnected  {
            return service.fetchAll()
        } else {
            return Single<PokemonListResponse>
                .create { single in
                    single(.failure(ListError.NoConnection))
                    return Disposables.create()
                }
        }
    }
}

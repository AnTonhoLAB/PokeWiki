//
//  PokemonListAllInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift

protocol PokemonListAllInteractorProtocol {
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse>
}

class PokemonListAllInteractor: PokemonListAllInteractorProtocol {
    
    let service: PokemonListAllServiceProtocol
    
    init(service: PokemonListAllServiceProtocol) {
        self.service = service
    }
    
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        if NetworkingManager.isConnected  {
            return service.fetchList(with: limit, offSet: offSet)
        } else {
            return Single<PokemonListResponse>
                .create { single in
                    single(.failure(PokemonListError.NoConnection))
                    return Disposables.create()
                }
        }
    }
}

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
    let networkingManager: NetworkingManagerProtocol
    
    init(service: PokemonListAllServiceProtocol, networkingManager: NetworkingManagerProtocol = NetworkingManager()) {
        self.service = service
        self.networkingManager = networkingManager
    }
    
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        guard networkingManager.isConnected()  else {
            return Single<PokemonListResponse>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        return service.fetchList(with: limit, offSet: offSet)
    }
}

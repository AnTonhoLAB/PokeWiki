//
//  ListAllInteractorMock.swift
//  PokeWikiTests
//
//  Created by George Vilnei Arboite Gomes on 13/01/22.
//

@testable import PokeWiki
import Foundation
import RxSwift

class ListAllInteractorMock: PokemonListInteractorProtocol {
    
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { single in
                let pokemonItens = [PokemonItem(name: "kakuna", url: "http://kakuna.com")]
                single(.success(PokemonListResponse(count: 1, next: "", previous: "", results: pokemonItens)))
                return Disposables.create()
            }
    }
}

class ListAllWithErrorInteractorMock: PokemonListInteractorProtocol {
    
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { single in
                single(.failure(PokemonListError.internalError))
                return Disposables.create()
            }
    }
}

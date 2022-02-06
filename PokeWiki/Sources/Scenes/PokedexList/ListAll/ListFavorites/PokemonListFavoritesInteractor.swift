//
//  PokemonListFavoritesInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 05/02/22.
//

import Foundation
import RxSwift

class PokemonListFavoritesInteractor: PokemonListInteractorProtocol {
    
    private let persistenceManager = PersistenceManager()
   
    init() {
        
    }
    
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
                    .create {  single in
                        if let pokemonEntity = try? self.persistenceManager.fetch(PokemonEntity.self) {
                            let pokemons: [PokemonItem] = pokemonEntity
                                .compactMap { $0.pokemonDetail }
                                .compactMap { return try? JSONDecoder().decode(PokemonDetail.self, from: $0) }
                                .map { PokemonItem(name: $0.name, url: "pokemon/\($0.id)")}
                            single(.success(PokemonListResponse(count: pokemons.count, next: nil, previous: nil, results: pokemons)))
                        } else {
                            single(.failure(CoreDataError.couldNotFetchObject))
                        }
                        return Disposables.create()
                    }
    }
}

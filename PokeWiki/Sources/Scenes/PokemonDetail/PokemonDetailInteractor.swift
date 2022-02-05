//
//  PokemonDetailInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

protocol PokemonDetailInteractorProtocol {
    func fetchAPokemon(with name: String) -> Single<PokemonDetail>
    func fetchPokemonImage(for id: Int) -> Single<Data>
}

class PokemonDetailInteractor: PokemonDetailInteractorProtocol {
    
    let service: PokemonDetailServiceProtocol
    let networkingManager: NetworkingManagerProtocol
    private let persistenceManager = PersistenceManager()
    
    init(service: PokemonDetailServiceProtocol, networkingManager: NetworkingManagerProtocol = NetworkingManager()) {
        self.service = service
        self.networkingManager = networkingManager
    }
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        guard networkingManager.isConnected()  else {
            return Single<PokemonDetail>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        return service.fetchAPokemon(with: name)
    }
    
    func fetchPokemonImage(for id: Int) -> Single<Data> {
        guard networkingManager.isConnected()  else {
            return Single<Data>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        return service.fechPokemonImage(for: id)
    }
    
    func favorite(pokemon: inout PokemonDetail) throws {
        
        pokemon.fromPersistence = true
        
        do {
            let pokemonToSave = try persistenceManager.create(PokemonEntity.self)
            pokemonToSave.pokemonDetail = try JSONEncoder().encode(pokemon)
            try persistenceManager.save()
        } catch  {
            throw error
        }
    }
}

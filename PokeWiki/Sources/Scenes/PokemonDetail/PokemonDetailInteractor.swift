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
    func favoriteToogle(pokemon: PokemonDetail) throws 
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
    
    func favoriteToogle(pokemon: PokemonDetail) throws {
        
        switch pokemon.fromPersistence {
        case true:
            try removePokemon(pokemon: pokemon)
        case false:
            try savePokemon(pokemon: pokemon)
        }
    }
    
    private func savePokemon(pokemon: PokemonDetail) throws {
        pokemon.togglePersistence()
        
        do {
            let pokemonToSave = try persistenceManager.create(PokemonEntity.self)
            pokemonToSave.id = "\(pokemon.id)"
            pokemonToSave.pokemonDetail = try JSONEncoder().encode(pokemon)
            try persistenceManager.save()
        } catch  {
            throw error
        }
    }
    
    private func removePokemon(pokemon: PokemonDetail) throws {
        pokemon.togglePersistence()
        
        do {
            try persistenceManager.delete(PokemonEntity.self, id: 1)
        } catch  {
            throw error
        }
    }
}

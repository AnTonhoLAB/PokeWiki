//
//  PokemonDetailInteractor.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift

enum ManagedDataResult {
    case added
    case deleted
    case error
}

extension ManagedDataResult {
    var localizedDescription: String {
        switch self {
        case .added:
            return "The Pokemon was saved successfully"
        case .deleted:
            return "the pokemon has been removed from your favorites"
        case .error:
            return "Error, could not complete action"
        }
    }
}

protocol PokemonDetailInteractorProtocol {
    func fetchAPokemon(with name: String) -> Single<PokemonDetail>
    func fetchPokemonImage(for id: Int) -> Single<Data>
    func favoriteToogle(pokemon: PokemonDetail) throws -> ManagedDataResult
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
        // Primeiro verifica se já esta no core data
        // Procura o pokemon no core data pelo nome
        if let pokemonEntity = try? persistenceManager.fetchSingle(PokemonEntity.self, name: name),
           let pokemonDetail = pokemonEntity.pokemonDetail,
           let pokemon = try? JSONDecoder().decode(PokemonDetail.self, from: pokemonDetail)  {
            return Single<PokemonDetail>
                        .create { single in
                            pokemon.togglePersistence()
                            single(.success(pokemon))
                            return Disposables.create()
                        }
        }
        
        // Se não estiver no core data, então verifica se há conexão com a internet
        guard networkingManager.isConnected()  else {
            return Single<PokemonDetail>
                        .create { single in
                            single(.failure(PokemonListError.NoConnection))
                            return Disposables.create()
                        }
        }
        
        // Se houver conexão chama o serviço para buscar o pokemon pelo nome
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
    
    func favoriteToogle(pokemon: PokemonDetail) throws -> ManagedDataResult {
        
        switch pokemon.fromPersistence {
        case true:
            return try removePokemon(pokemon: pokemon)
        case false:
            return try savePokemon(pokemon: pokemon)
        }
    }
    
    private func savePokemon(pokemon: PokemonDetail) throws -> ManagedDataResult {
        
        do {
            let pokemonToSave = try persistenceManager.create(PokemonEntity.self)
            pokemonToSave.id = Double(pokemon.id)
            pokemonToSave.name = pokemon.name
            pokemon.togglePersistence()
            
            pokemonToSave.pokemonDetail = try JSONEncoder().encode(pokemon)
            try persistenceManager.save()
            return .added
        } catch  {
            throw error
        }
    }
    
    private func removePokemon(pokemon: PokemonDetail) throws -> ManagedDataResult {
        pokemon.togglePersistence()
        
        do {
            try persistenceManager.delete(PokemonEntity.self, id: pokemon.id)
            return .deleted
        } catch  {
            throw error
        }
    }
}

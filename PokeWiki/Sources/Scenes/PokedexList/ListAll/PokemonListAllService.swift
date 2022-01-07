//
//  PokemonListService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift

protocol PokemonListAllServiceProtocol {
    func fetchAll() -> Single<PokemonListResponse>
}

final class PokemonListAllService: PokemonListAllServiceProtocol {
    func fetchAll() -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { single in
                let pokemonItem = PokemonItem(name: "bulbasaur", url: "")
                let response = PokemonListResponse(count: 1, next: "", previous: "", results: [pokemonItem])
                single(.success(response))
                return Disposables.create()
            }
    }
}

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}

struct PokemonItem: Decodable {
    let name: String
    let url: String
}

enum PokemonListError: Error {
    case NoConnection
}

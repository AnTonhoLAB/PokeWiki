//
//  PokemonListResponse.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - PokemonListResponse
struct PokemonListResponse: Decodable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}


//
//  PokemonItem.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - PokemonItem
struct PokemonItem: Decodable, Equatable {
    let name: String
    let url: String
}

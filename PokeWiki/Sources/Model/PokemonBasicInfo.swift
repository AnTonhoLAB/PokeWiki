//
//  PokemonBasicInfo.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 16/01/22.
//

import Foundation

// MARK: - PokemonBasicInfo
struct PokemonBasicInfo {
    let id: Int
    let name: String
    let type: [TypeElement]
    let isFavorite: Bool
}

struct PokemonBioInfo {
    let height: Double
    let weight: Double
}

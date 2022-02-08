//
//  PokemonDetail.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - PokemonDetail
class PokemonDetail: Codable, Equatable {
    
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    var fromPersistence = false
    let abilities: [Ability]
    let baseExperience: Int
    let forms: [Species]
    let gameIndices: [GameIndex]
    let height: Double
    let id: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let moves: [Move]
    let name: String
    let order: Int
    let species: Species
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Double
    let sprites: Sprites
    
    var mainType: PokemonType {
        return types.first?.type.name ?? PokemonType.unknown
    }
    
    internal init(fromPersistence: Bool = false, abilities: [Ability], baseExperience: Int, forms: [Species], gameIndices: [GameIndex], height: Double, id: Int, isDefault: Bool, locationAreaEncounters: String, moves: [Move], name: String, order: Int, species: Species, stats: [Stat], types: [TypeElement], weight: Double, sprites: Sprites) {
        self.fromPersistence = fromPersistence
        self.abilities = abilities
        self.baseExperience = baseExperience
        self.forms = forms
        self.gameIndices = gameIndices
        self.height = height
        self.id = id
        self.isDefault = isDefault
        self.locationAreaEncounters = locationAreaEncounters
        self.moves = moves
        self.name = name
        self.order = order
        self.species = species
        self.stats = stats
        self.types = types
        self.weight = weight
        self.sprites = sprites
    }

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves, name, order
        case species, stats, types, weight
        case sprites
    }
    
    func togglePersistence() {
        self.fromPersistence.toggle()
    }
}

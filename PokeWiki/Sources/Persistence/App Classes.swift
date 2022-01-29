//
//  App Classes.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import UIKit

struct PokemonListResponse: Decodable, Equatable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}

struct PokemonItem: Decodable, Equatable {
    let name: String
    let url: String
}

enum PokemonListError: Error {
    case internalError
    case NoConnection
}

extension PokemonListError {
    var localizedDescription: String {
        switch self {
        case .internalError:
            return "Internal error, try again"
        case .NoConnection:
            return "No connection, turn on the internet and try again"
        }
    }
}

enum PokemonType: String, Codable {
    
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
    
    func color() -> UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.6594975591, green: 0.6579902172, blue: 0.470580101, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.5896615696, green: 0.1413095594, blue: 0.05477729757, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.7350213434, green: 0.5857658941, blue: 1, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.5944519139, green: 0.0970109588, blue: 0.9686274529, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .fire:
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .electric:
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 0.9254902005, green: 0.3827843903, blue: 0.492022982, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.2116987177, green: 0.2116987177, blue: 0.2116987177, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 0.9251476526, green: 0.310475969, blue: 0.8065521193, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .shadow:
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
}

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

// MARK: - PokemonDetail
struct PokemonDetail: Codable, Equatable {
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
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
}

class Sprites: Codable {
    let backDefault: String?
    let backFemale: String?
    let backShiny: String?
    let backShinyFemale: String?
    let frontDefault: String?
    let frontFemale: String?
    let frontShiny: String?
    let frontShinyFemale: String?
    let other: OtherSprites
    
    init(backDefault: String? = nil, backFemale: String? = nil, backShiny: String? = nil, backShinyFemale: String? = nil, frontDefault: String? = nil, frontFemale: String? = nil, frontShiny: String? = nil, frontShinyFemale: String? = nil, other: OtherSprites) {
        
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
        self.other = other
    }

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other
    }
}

// MARK: - Other
struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - Ability
struct Ability: Codable {
    let ability: Species
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Species
struct Species: Codable {
    let name: String
    let url: String
}

// MARK: - GameIndex
struct GameIndex: Codable {
    let gameIndex: Int
    let version: Species

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

// MARK: - Move
struct Move: Codable {
    let move: Species
    let versionGroupDetails: [VersionGroupDetail]

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

// MARK: - VersionGroupDetail
struct VersionGroupDetail: Codable {
    let levelLearnedAt: Int
    let moveLearnMethod, versionGroup: Species

    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Stat
struct Stat: Codable {
    let baseStat, effort: Int
    var stat: StatInfo

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

enum StatName {
    case hp
    case attack
    case defense
    case special_attack
    case special_defense
    case speed
    
    init?(name: String) {
        switch name  {
        case "hp":
            self = .hp
        case "attack":
            self = .attack
        case "defense":
            self = .defense
        case "special-attack":
            self = .special_attack
        case "special-defense":
            self = .special_defense
        case "speed":
            self = .speed
        default:
            return nil
        }
    }
    
    func getColor () -> UIColor {
        switch self {
        case .hp:
            return #colorLiteral(red: 0.1233642325, green: 0.9913472533, blue: 0.4012124836, alpha: 1)
        case .attack:
            return #colorLiteral(red: 0.9838288426, green: 0.5258914828, blue: 0.4574290514, alpha: 1)
        case .defense:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case .special_attack:
            return #colorLiteral(red: 0.9969050288, green: 0.3966171145, blue: 0.2911958098, alpha: 1)
        case .special_defense:
            return #colorLiteral(red: 0.09446146339, green: 1, blue: 0.941624105, alpha: 1)
        case .speed:
            return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        }
    }
}

struct StatInfo: Codable {
    let name: String
    let url: String
    
    var statName: StatName? {
        return StatName(name: self.name)
    }
}

// MARK: - TypeElement
struct TypeElement: Codable {
    let slot: Int
    let type: SpecieType
}

struct SpecieType: Codable {
    let name: PokemonType
    let url: String
}


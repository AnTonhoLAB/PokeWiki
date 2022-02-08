//
//  PokemonType.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import UIKit

// MARK: - PokemonType
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

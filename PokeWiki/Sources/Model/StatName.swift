//
//  StatName.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import UIKit

// MARK: - StatName
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

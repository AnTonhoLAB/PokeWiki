//
//  StatInfo.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - StatInfo
struct StatInfo: Codable {
    let name: String
    let url: String
    
    var statName: StatName? {
        return StatName(name: self.name)
    }
}

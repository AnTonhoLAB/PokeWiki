//
//  Stat.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - Stat
struct Stat: Codable {
    let baseStat, effort: Int
    var stat: StatInfo

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

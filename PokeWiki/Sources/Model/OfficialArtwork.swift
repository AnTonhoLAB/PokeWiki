//
//  OfficialArtwork.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

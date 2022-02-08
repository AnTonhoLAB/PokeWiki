//
//  Move.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

// MARK: - Move
struct Move: Codable {
    let move: Species
    let versionGroupDetails: [VersionGroupDetail]

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

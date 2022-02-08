//
//  PokemonListError.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/02/22.
//

import Foundation

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

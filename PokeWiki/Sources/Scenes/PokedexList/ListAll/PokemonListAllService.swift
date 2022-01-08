//
//  PokemonListService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift
import Alamofire

protocol PokemonListAllServiceProtocol {
    func fetchAll() -> Single<PokemonListResponse>
}

final class PokemonListAllService: PokemonListAllServiceProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/"
    private let listAllEndPoint = "pokemon"
    
    func fetchAll() -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { [weak self] single in
                
                guard let self = self else {
                    single(.failure(PokemonListError.internalError))
                    return Disposables.create()
                }
                
                AF.request("\(self.baseURL+self.listAllEndPoint)")
                    .responseDecodable(of: PokemonListResponse.self) { (response) in
                        if let pokemons = response.value {
                            single(.success(pokemons))
                        }
                        
                        if let error = response.error {
                            single(.failure(error))
                        }
                }
                return Disposables.create()
            }
    }
}

struct PokemonListResponse: Decodable {
//    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonItem]
}

struct PokemonItem: Decodable {
    let name: String
    let url: String
}

enum PokemonListError: Error {
    case internalError
    case NoConnection
}

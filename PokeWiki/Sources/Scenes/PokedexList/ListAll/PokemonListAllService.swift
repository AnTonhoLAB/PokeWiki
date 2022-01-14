//
//  PokemonListService.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift

protocol PokemonListAllServiceProtocol {
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse>
}

private enum URLParams: String {
    case limit
    case offset
}

final class PokemonListAllService: PokemonListAllServiceProtocol, RequesterProtocol {
        
    private let baseURL = "https://pokeapi.co/api/v2/pokemon"
    func fetchList(with limit: Int, offSet: Int) -> Single<PokemonListResponse> {
        return Single<PokemonListResponse>
            .create { [weak self, baseURL] single in
                
                let params = [URLParams.limit.rawValue: "\(limit)", URLParams.offset.rawValue: "\(offSet)"]
                self?.makeRequest(url: baseURL, urlParams: params, single: single)
                return Disposables.create()
            }
    }
}

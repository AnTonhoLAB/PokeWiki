//
//  RequesterProtocol.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import Alamofire

protocol RequesterProtocol {
    
}

extension RequesterProtocol {
    
    // Generic function to call Alamofire and return espected type
    func makeRequest<T>(url: String, single: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        AF.request(url)
            .responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    single(.failure(error))
                }
        }
    }
}

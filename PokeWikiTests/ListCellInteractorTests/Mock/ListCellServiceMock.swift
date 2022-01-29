//
//  File.swift
//  PokeWikiTests
//
//  Created by George Vilnei Arboite Gomes on 13/01/22.
//

@testable import PokeWiki
import Foundation
import RxSwift

class ListCellServiceMock: PokemonDetailServiceProtocol {
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        return Single<PokemonDetail>
            .create { single in
                
                let specie = Species(name: "species", url: "http://species")
                let indice = GameIndex(gameIndex: 1, version: specie)
                let move = Move(move: specie, versionGroupDetails: [VersionGroupDetail(levelLearnedAt: 1, moveLearnMethod: specie, versionGroup: specie)])
                let statInfo = StatInfo(name: "species", url: "http://species")
                let stat = Stat(baseStat: 1, effort: 1, stat: statInfo)
                let type = PokemonType.normal
                let specieType = SpecieType(name: type, url: "http://species")
                let typeElement = TypeElement(slot: 1, type: specieType)
                let officialArtwork = OfficialArtwork(frontDefault: "Front")
                let other = OtherSprites(officialArtwork: officialArtwork)
                let sprites = Sprites(other: other)
                
                
                let pokemonDetail = PokemonDetail(abilities: [], baseExperience: 1, forms: [specie], gameIndices: [indice], height: 1, id: 1, isDefault: true, locationAreaEncounters: "", moves: [move], name: "", order: 1, species: specie, stats: [stat], types: [typeElement], weight: 1, sprites: sprites)
                
                single(.success(pokemonDetail))
                return Disposables.create()
            }
    }
    
    func fechPokemonImage(for id: Int) -> Single<Data> {
        return Single<Data>
            .create { single in
                let data = #imageLiteral(resourceName: "PokeDexIcon").pngData() ?? Data()
                
                single(.success(data))
                return Disposables.create()
            }
    }
}

class ListCellServiceMockError: PokemonDetailServiceProtocol {
    
    func fetchAPokemon(with name: String) -> Single<PokemonDetail> {
        return Single<PokemonDetail>
            .create { single in
                single(.failure(MockError.generic))
                return Disposables.create()
            }
    }
    
    func fechPokemonImage(for id: Int) -> Single<Data> {
        return Single<Data>
            .create { single in
                single(.failure(MockError.generic))
                return Disposables.create()
            }
    }
}

enum MockError: Error {
    case generic
}

class NetworkMock: NetworkingManagerProtocol {
    func isConnected() -> Bool {
        true
    }
}

class NetworkMockError: NetworkingManagerProtocol {
    func isConnected() -> Bool {
        false
    }
}

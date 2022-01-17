//
//  ListCellInteractorTests.swift
//  PokeWikiTests
//
//  Created by George Vilnei Arboite Gomes on 13/01/22.
//

import Quick
import Nimble
import RxTest
import RxSwift
import GGDevelopmentKit

@testable import PokeWiki

class ListCellInteractorTests: QuickSpec {
    
    private var sut: PokemonDetailInteractor!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    func setUpTests() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func spec() {
        tests()
    }
    
    private func tests() {
      
        describe("Interactor que verifica a conecção e chama o detalhe do pokemon") {
            
            context("Quando o interactor chama o detalhe com sucesso") {

                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonDetailInteractor(service: ListCellServiceMock(), networkingManager: NetworkMock())
                }
                
                it("Então retorna o detalhe") {
                    let detail = self.scheduler.createObserver(PokemonDetail.self)
                    
                    self.sut.fetchAPokemon(with: "")
                        .asObservable()
                        .subscribe(detail)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    
                    let specie = Species(name: "species", url: "http://species")
                    let indice = GameIndex(gameIndex: 1, version: specie)
                    let move = Move(move: specie, versionGroupDetails: [VersionGroupDetail(levelLearnedAt: 1, moveLearnMethod: specie, versionGroup: specie)])
                    let stat = Stat(baseStat: 1, effort: 1, stat: specie)
                    let type = PokemonType.normal
                    let specieType = SpecieType(name: type, url: "http://species")
                    let typeElement = TypeElement(slot: 1, type: specieType)
                    let officialArtwork = OfficialArtwork(frontDefault: "Front")
                    let other = OtherSprites(officialArtwork: officialArtwork)
                    let sprites = Sprites(other: other)
                    
                    
                    let pokemonDetail = PokemonDetail(abilities: [], baseExperience: 1, forms: [specie], gameIndices: [indice], height: 1, id: 1, isDefault: true, locationAreaEncounters: "", moves: [move], name: "", order: 1, species: specie, stats: [stat], types: [typeElement], weight: 1, sprites: sprites)
                    
                    expect(detail.events).to(equal([.next(0, pokemonDetail), .completed(0)]))
                }
            }
        }
        
        describe("Interactor que verifica a conecção e chama o detalhe do pokemon") {
            
            context("Quando o interactor chama o detalhe com erro") {

                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonDetailInteractor(service: ListCellServiceMockError(), networkingManager: NetworkMock())
                }
                
                it("Então retorna o detalhe") {
                    let detail = self.scheduler.createObserver(PokemonDetail.self)
                    
                    self.sut.fetchAPokemon(with: "")
                        .asObservable()
                        .subscribe(detail)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    expect(detail.events).to(equal([.error(0, MockError.generic)]))
                }
            }
        }
        
        describe("Interactor que verifica a conecção") {
            
            context("Quando o interactor chama o detalhe mas internete está desligada") {

                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonDetailInteractor(service: ListCellServiceMockError(), networkingManager: NetworkMockError())
                }
                
                it("Então retorna o detalhe") {
                    let detail = self.scheduler.createObserver(PokemonDetail.self)
                    
                    self.sut.fetchAPokemon(with: "")
                        .asObservable()
                        .subscribe(detail)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    expect(detail.events).to(equal([.error(0, PokemonListError.NoConnection)]))
                }
            }
            
            context("Quando o interactor chama a imagem mas internete está desligada") {

                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonDetailInteractor(service: ListCellServiceMockError(), networkingManager: NetworkMockError())
                }
                
                it("Então retorna o detalhe") {
                    let detail = self.scheduler.createObserver(Data.self)
                    
                    self.sut.fetchPokemonImage(for: 1)
                        .asObservable()
                        .subscribe(detail)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    expect(detail.events).to(equal([.error(0, PokemonListError.NoConnection)]))
                }
            }
        }
    }
}

//
//  ListAllViewModelTests.swift
//  PokeWikiTests
//
//  Created by George Vilnei Arboite Gomes on 12/01/22.
//

import Quick
import Nimble
import RxTest
import RxSwift
import GGDevelopmentKit

@testable import PokeWiki

class ListAllViewModelTests: QuickSpec {
    
    private var sut: PokemonListAllViewModel!
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
      
        describe("View model que faz a chamada de listagem de todos pokemons") {
            
            context("Quando o usuario abre a tela e a listagem é chamada com sucesso") {

                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonListAllViewModel(interactor: ListAllInteractorMock())

                    self.scheduler.createColdObservable([.next(10, (true)),
                                                         .next(20, (true))])
                        .bind(to: self.sut.viewDidLoad)
                        .disposed(by: self.disposeBag)
                }
                
                it("Então o estatus fica loading e depois sucesso") {
                    let state = self.scheduler.createObserver(Navigation<PokemonListAllViewModel.State>.self)
                    
                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    
                    let stateLoading : Navigation<PokemonListAllViewModel.State> = Navigation(type: .loading)
                    let stateSuccess : Navigation<PokemonListAllViewModel.State> = Navigation(type: .success)

                    expect(state.events).to(equal([.next(10, stateLoading),
                                                   .next(10, stateSuccess),
                                                   .next(20, stateLoading),
                                                   .next(20, stateSuccess)
                                                   ]))
                }

                it("Então a lista é preenchida") {
                    let pokemonList = self.scheduler.createObserver([PokemonItem].self)
                    let state = self.scheduler.createObserver(Navigation<PokemonListAllViewModel.State>.self)

                    self.sut.pokemonList
                        .drive(pokemonList)
                        .disposed(by: self.disposeBag)

                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)

                    self.scheduler.start()
                    expect(pokemonList.events).to(equal([.next(0, []),
                                                         .next(10, [PokemonItem(name: "kakuna", url: "http://kakuna.com")]),
                                                         .next(20, [PokemonItem(name: "kakuna", url: "http://kakuna.com")])
                    ]))
                }
            }
            
            context("Quando o usuario abre a tela e a listagem é chamada com erro") {
                
                afterEach {
                    self.sut = nil
                }
                
                beforeEach {
                    self.setUpTests()
                    self.sut = PokemonListAllViewModel(interactor: ListAllWithErrorInteractorMock())
                    
                    self.scheduler.createColdObservable([.next(10, (true))])
                        .bind(to: self.sut.viewDidLoad)
                        .disposed(by: self.disposeBag)
                }
                
                it("Então o estatus fica loading e depois error") {
                    let state = self.scheduler.createObserver(Navigation<PokemonListAllViewModel.State>.self)
                    
                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)
                    
                    self.scheduler.start()
                    
                    let stateLoading : Navigation<PokemonListAllViewModel.State> = Navigation(type: .loading)
                    let stateError : Navigation<PokemonListAllViewModel.State> = Navigation(type: .error)

                    expect(state.events).to(equal([.next(10, stateLoading),
                                                   .next(10, stateError)]))
                }
                
                it("Então a lista fica vazia") {
                    let pokemonList = self.scheduler.createObserver([PokemonItem].self)
                    let state = self.scheduler.createObserver(Navigation<PokemonListAllViewModel.State>.self)

                    self.sut.pokemonList
                        .drive(pokemonList)
                        .disposed(by: self.disposeBag)

                    self.sut.serviceState
                        .asDriver()
                        .drive(state)
                        .disposed(by: self.disposeBag)

                    self.scheduler.start()

                    expect(pokemonList.events).to(equal([.next(0, [])]))
                }
            }
        }
    }
}

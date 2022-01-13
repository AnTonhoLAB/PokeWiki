//
//  ListAllInteractorTests.swift
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

class ListAllInteractorTests: QuickSpec {
    private var sut: PokemonListAllInteractor!
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
                    self.sut = PokemonListAllInteractor(service: ListAllServiceMock(), networkingManager: NetworkMockError())
                }
                
                it("Então retorna o detalhe") {
                    let detail = self.scheduler.createObserver(PokemonListResponse.self)
                    
                    self.sut.fetchList(with: 1, offSet: 1)
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

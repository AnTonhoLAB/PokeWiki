//
//  PokemonListCellViewModel.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit

protocol PokemonListCellViewModelProtocol {
    
    // MARK: - Inputs
    var viewWillAppear: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var name: String { get }
    var serviceState: Driver<Navigation<PokemonListCellViewModel.State>> { get }
    var pokemonDetail: Driver<PokemonDetail> { get }
}

final class PokemonListCellViewModel: PokemonListCellViewModelProtocol {
    
    typealias ServiceState = Navigation<State>
    private let interactor: PokemonListCellInteractorProtocol
    private let pokemonResponse = PublishSubject<PokemonDetail>()
    
    // MARK: - Inputs
    let viewWillAppear: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    let name: String
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var pokemonDetail: Driver<PokemonDetail>
    
    // MARK: - Initializer
    init(name: String, interactor: PokemonListCellInteractorProtocol) {
        self.name = name
        self.interactor = interactor
        self.pokemonDetail = pokemonResponse.asDriverOnErrorJustComplete()
        self.serviceState = createServiceState(with: name)
    }
    
    // MARK: - Internal methods
    private func createServiceState(with name: String) -> Driver<ServiceState> {
            
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let fetchDetail = interactor.fetchAPockemon(with: name)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .do(onNext: { [pokemonResponse] pokemonDetail in
                
               pokemonResponse.onNext(pokemonDetail)
            })
            .map { ServiceState(type: .success, info: $0) }
            .catch { (error) -> Observable<Navigation<State>> in
                return .just(ServiceState(type: .error))
            }
        
        let loadDetail = viewWillAppear
            .flatMapLatest { _ -> Observable<ServiceState> in
                fetchDetail
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadingShown, loadDetail, errorToShow)
            .asDriver(onErrorJustReturn: ServiceState(type: .error))
    }
    
}

// MARK: - Helpers
extension PokemonListCellViewModel {
    
    // MARK: - Route
    enum Route: Int, Equatable {
        case openDetail
    }
    
    // MARK: - State
    enum State: Equatable {
        case loading
        case success
        case error
    }
}

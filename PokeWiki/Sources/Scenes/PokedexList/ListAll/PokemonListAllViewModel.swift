//
//  PokemonListAllViewModel.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit

protocol PokemonListAllViewModelProtocol {
    
    // MARK: - Inputs
    var viewDidLoad: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var serviceState: Driver<Navigation<PokemonListAllViewModel.State>> { get }
    var pokemonList: Driver<[PokemonItem]> { get }
}

final class PokemonListAllViewModel: PokemonListAllViewModelProtocol {
    
    typealias ServiceState = Navigation<State>
    
    // MARK: - Internal properties
    private let interactor: PokemonListAllInteractorProtocol
    private let pokemonListResponse = BehaviorRelay<[PokemonItem]>(value: [])
    private let paginationSupport: GGPaginationSupport = GGPaginationSupport(limit: 20)
    
    // MARK: - Inputs
    let viewDidLoad: PublishSubject<Void> = .init()
    let loadMore: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var pokemonList: Driver<[PokemonItem]>
    
    // MARK: - Initializer
    init(interactor: PokemonListAllInteractorProtocol) {
        self.interactor = interactor
        self.pokemonList = pokemonListResponse.asDriverOnErrorJustComplete()
        self.serviceState = createServiceState()
    }
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        /// Triger when start to load
        let startLoad = Observable.merge([viewDidLoad, loadMore])
        /// Function to load Pokemons
        let fetchPokemons = {
            return self.interactor.fetchList(with: self.paginationSupport.limit, offSet: self.paginationSupport.offSet)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .do(onNext: { [weak self] (pokemonResponse) in
                    guard let self = self else { return }

                    self.pokemonListResponse.accept(self.pokemonListResponse.value + pokemonResponse.results)
                    self.paginationSupport.size = pokemonResponse.count
                    self.paginationSupport.validateIsLast(count: self.pokemonListResponse.value.count)
                })
                .map { ServiceState(type: .success, info: $0) }
        }
            
        let loadList = startLoad
            .filter { self.paginationSupport.needCall() }
            .flatMapLatest { fetchPokemons() }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadingShown, loadList, errorToShow)
            .asDriver(onErrorJustReturn: ServiceState(type: .error))
    }
}

// MARK: - Helpers
extension PokemonListAllViewModel {
    
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

// MARK: - Actions
struct Actions {
    let back: PublishSubject<Void>
    let close: PublishSubject<Void>
    let next: PublishSubject<Void>
    
    init(back: PublishSubject<Void> = .init(),
         close: PublishSubject<Void> = .init(),
         next: PublishSubject<Void> = .init()) {
        self.back = back
        self.close = close
        self.next = next
    }
}

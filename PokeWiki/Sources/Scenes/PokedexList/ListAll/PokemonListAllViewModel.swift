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
    var didSelectItem: PublishSubject<PokemonItem> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<PokemonListAllViewModel.Route>> { get }
    var serviceState: Driver<Navigation<PokemonListAllViewModel.State>> { get }
    var pokemonList: Driver<[PokemonItem]> { get }
}

final class PokemonListAllViewModel: PokemonListAllViewModelProtocol {
    // MARK: - Definitions
    typealias ListNavigation = Navigation<Route>
    typealias ServiceState = Navigation<State>
    
    // MARK: - Internal properties
    private let interactor: PokemonListAllInteractorProtocol
    private let pokemonListResponse = BehaviorRelay<[PokemonItem]>(value: [])
    private let paginationSupport: GGPaginationSupport = GGPaginationSupport(limit: 20)
    
    // MARK: - Inputs
    let viewDidLoad: PublishSubject<Void> = .init()
    let loadMore: PublishSubject<Void> = .init()
    let didSelectItem: PublishSubject<PokemonItem> = .init()
    
    // MARK: - Outputs
    private(set) var navigation: Driver<ListNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var pokemonList: Driver<[PokemonItem]>
    
    // MARK: - Initializer
    init(interactor: PokemonListAllInteractorProtocol) {
        self.interactor = interactor
        self.pokemonList = pokemonListResponse.asDriverOnErrorJustComplete()
        
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
    }
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        /// Triger when start to load
        let startLoad = Observable.merge([viewDidLoad, loadMore])
        
        /// Function to load Pokemons
        let fetchPokemons = { [pokemonListResponse, paginationSupport, interactor] in
            return interactor.fetchList(with: paginationSupport.limit, offSet: paginationSupport.offSet)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .do(onNext: { [pokemonListResponse, paginationSupport] (pokemonResponse) in

                    pokemonListResponse.accept(pokemonListResponse.value + pokemonResponse.results)
                    paginationSupport.size = pokemonResponse.count
                    paginationSupport.validateIsLast(count: pokemonListResponse.value.count)
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
    
    // MARK: -Internal methods
    private func createNavigation() -> Driver<ListNavigation> {

        let routeToNext = didSelectItem
            .map { ListNavigation(type: .openDetail, info: $0) }
        
        return Observable.merge([routeToNext]
        )
            .asDriver(onErrorRecover: { _ in .never() })
    }
}

// MARK: - Helpers
extension PokemonListAllViewModel {
    
    // MARK: - Route
    enum Route: Equatable {
        case openDetail
    }
    
    // MARK: - State
    enum State: Equatable {
        case loading
        case success
        case error
    }
    
    // MARK: - Actions
    struct Actions {
        let next: PublishSubject<Void>
        
        init(next: PublishSubject<Void> = .init()) {
            self.next = next
        }
    }
}

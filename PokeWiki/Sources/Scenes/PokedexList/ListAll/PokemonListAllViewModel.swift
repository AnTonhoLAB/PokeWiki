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

class PokemonListViewModel {
    
}

protocol PokemonListViewModelProtocol {
    // MARK: - Inputs
    var viewDidLoad: PublishSubject<Bool> { get }
    var loadMore: PublishSubject<Bool> { get }
    var didSelectItem: PublishSubject<PokemonItem> { get }
    
    // MARK: - Outputs
    var navigation: Driver<Navigation<PokemonListViewModel.Route>> { get }
    var serviceState: Driver<Navigation<PokemonListViewModel.State>> { get }
    var pokemonList: Driver<[PokemonItem]> { get }
}

final class PokemonListAllViewModel: PokemonListViewModel, PokemonListViewModelProtocol {
    // MARK: - Definitions
    typealias ListNavigation = Navigation<Route>
    typealias ServiceState = Navigation<State>
    
    // MARK: - Internal properties
    private let interactor: PokemonListInteractorProtocol
    private let pokemonListResponse = BehaviorRelay<[PokemonItem]>(value: [])
    private let paginationSupport: GGPaginationSupport = GGPaginationSupport(limit: 20)
    
    // MARK: - Inputs
    let viewDidLoad: PublishSubject<Bool> = .init()
    let loadMore: PublishSubject<Bool> = .init()
    let didSelectItem: PublishSubject<PokemonItem> = .init()
    
    // MARK: - Outputs
    private(set) var navigation: Driver<ListNavigation> = .never()
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var pokemonList: Driver<[PokemonItem]>
    
    // MARK: - Initializer
    init(interactor: PokemonListInteractorProtocol) {
        self.interactor = interactor
        self.pokemonList = pokemonListResponse.asDriverOnErrorJustComplete()
        super.init()
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
    }
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        
        /// Triger when start to load
        let startLoad = Observable.merge([viewDidLoad, loadMore])
        
        /// Function to load Pokemons
        let fetchPokemons: (_ reload: Bool) -> Observable<PokemonListAllViewModel.ServiceState> = { [pokemonListResponse, paginationSupport, interactor] (reload)  in
            return interactor.fetchList(with: paginationSupport.limit, offSet: paginationSupport.offSet)
                .trackActivity(activityIndicator)
                .do(onNext: { [pokemonListResponse, paginationSupport] (pokemonResponse) in
                    let newValue = reload ? pokemonResponse.results : pokemonListResponse.value + pokemonResponse.results
                    pokemonListResponse.accept(newValue)
                    paginationSupport.size = pokemonResponse.count
                    paginationSupport.validateIsLast(count: pokemonListResponse.value.count)
                })
                .map { ServiceState(type: .success, info: $0) }
                .catch { err in
                    return .just(ServiceState(type: .error, info: err))
                }
        }
            
        let loadList = startLoad
            .filter { reload in self.paginationSupport.needCall(reload: reload) }
            .flatMapLatest { reload in
                fetchPokemons(reload)
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        return Observable
            .merge(loadingShown, loadList)
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
extension PokemonListViewModel {
    
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


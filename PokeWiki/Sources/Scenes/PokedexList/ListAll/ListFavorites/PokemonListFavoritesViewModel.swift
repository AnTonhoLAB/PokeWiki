//
//  PokemonListFavoritesViewModel.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 05/02/22.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit
import CoreData

class PokemonListFavoritesViewModel: PokemonListViewModel, PokemonListViewModelProtocol {
    var updateUI: (() -> Void)
    
    var titleText: UIImage {
        return #imageLiteral(resourceName: "ListBG")
    }
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
    private(set) var navigation: Driver<Navigation<PokemonListViewModel.Route>> = .never()
    private(set) var serviceState: Driver<Navigation<PokemonListViewModel.State>> = .never()
    private(set) var pokemonList: Driver<[PokemonItem]> = .never()
    
    // MARK: - Initializer
    init(interactor: PokemonListInteractorProtocol) {
        self.interactor = interactor
        self.pokemonList = pokemonListResponse.asDriverOnErrorJustComplete()
        self.updateUI = {
            
        }
        super.init()
        self.serviceState = createServiceState()
        self.navigation = createNavigation()
        
        // Escuta mudanças no coredata
        let context = PersistentContainer.shared.viewContext
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    // MARK: - Internal methods
    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification) {
        //reload na collection
        viewDidLoad.onNext(true)
    }
    
    private func createServiceState() -> Driver<ServiceState> {
                
        let activityIndicator = ActivityIndicator()
        
        /// Triger when start to load
        let startLoad = Observable.merge([viewDidLoad])
        
        /// Function to load Pokemons
        let fetchPokemons: (_ reload: Bool) -> Observable<PokemonListFavoritesViewModel.ServiceState> = { [pokemonListResponse, paginationSupport, interactor] (reload)  in
            return interactor.fetchList(with: paginationSupport.limit, offSet: paginationSupport.offSet)
                .trackActivity(activityIndicator)
                .do(onNext: { [pokemonListResponse] (pokemonResponse) in
                    pokemonListResponse.accept(pokemonResponse.results)
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
        
        return Observable.merge([routeToNext])
            .asDriver(onErrorRecover: { _ in .never() })
    }
}


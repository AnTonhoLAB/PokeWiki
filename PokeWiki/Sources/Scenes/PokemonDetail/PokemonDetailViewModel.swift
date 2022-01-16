//
//  PokemonDetailViewModel.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 08/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import GGDevelopmentKit

protocol PokemonDetailViewModelProtocol {
    
    // MARK: - Inputs
    var viewWillAppear: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var name: String { get }
    var serviceState: Driver<Navigation<PokemonDetailViewModel.State>> { get }
    var pokemonDetail: Driver<PokemonDetail> { get }
    var pokemonImage: Driver<Data> { get }
}

final class PokemonDetailViewModel: PokemonDetailViewModelProtocol {
    
    typealias ServiceState = Navigation<State>
    private let interactor: PokemonDetailInteractorProtocol
    private let pokemonResponse = PublishSubject<PokemonDetail>()
    private let pokemonImageResponse = PublishSubject<Data>()
    
    // MARK: - Inputs
    let viewWillAppear: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    let name: String
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var pokemonDetail: Driver<PokemonDetail>
    private(set) var pokemonImage: Driver<Data>
    
    // MARK: - Initializer
    init(name: String, url: String, interactor: PokemonDetailInteractorProtocol) {
        self.name = name
        self.interactor = interactor
        self.pokemonDetail = pokemonResponse.asDriverOnErrorJustComplete()
        self.pokemonImage = pokemonImageResponse.asDriverOnErrorJustComplete()
        self.serviceState = createServiceState(with: name, url: url)
    }
    
    // MARK: - Internal methods
    private func createServiceState(with name: String, url: String) -> Driver<ServiceState> {
            
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let fetchDetail = interactor.fetchAPokemon(with: name)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .do(onNext: { [pokemonResponse] pokemonDetail in
                
               pokemonResponse.onNext(pokemonDetail)
            })
            .map { ServiceState(type: .success, info: $0) }

        let idStr = url.getId()
        let id = idStr.parseToIntOrZero()
        
        let fetchImage = interactor.fetchPokemonImage(for: id)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .do(onNext: { [pokemonImageResponse] pokemonImage in
                pokemonImageResponse.onNext(pokemonImage)
            })
            .map { ServiceState(type: .success, info: $0) }
        
        let loadDetail = viewWillAppear
            .flatMapLatest { _ -> Observable<ServiceState> in
                fetchDetail
            }
        
        let loadImage = viewWillAppear
            .flatMapLatest { _ -> Observable<ServiceState> in
                fetchImage
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()
        
        let errorToShow = errorTracker
            .map { ServiceState(type: .error, info: $0)}
            .asObservable()
        
        return Observable
            .merge(loadingShown, loadDetail, loadImage, errorToShow)
            .asDriver(onErrorJustReturn: ServiceState(type: .error))
    }
    
}

// MARK: - Helpers
extension PokemonDetailViewModel {
    
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

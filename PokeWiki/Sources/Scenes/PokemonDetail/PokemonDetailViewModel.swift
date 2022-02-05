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

protocol PokemonBasicDetailViewModelProtocol {
    
    // MARK: - Inputs
    var viewWillAppear: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var name: String { get }
    var serviceState: Driver<Navigation<PokemonBasicDetailViewModel.State>> { get }
    var basicInfo: Observable<PokemonBasicInfo> { get }
    var pokemonImage: Observable<Data> { get }
}

protocol PokemonFullDetailViewModelProtocol: PokemonBasicDetailViewModelProtocol {
    // MARK: - Inputs
    var didTapFavorite: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var typeinfoColor: Observable<UIColor> { get }
    var bioInfo: Observable<PokemonBioInfo> { get }
    var status: Observable<[Stat]> { get }
}

class PokemonBasicDetailViewModel: PokemonBasicDetailViewModelProtocol {
    
    typealias ServiceState = Navigation<State>
    private let interactor: PokemonDetailInteractorProtocol
    fileprivate let pokemonResponse = PublishSubject<PokemonDetail>()
    private let pokemonImageResponse = PublishSubject<Data>()
    
    // MARK: - Inputs
    let viewWillAppear: PublishSubject<Void> = .init()
    let tapFavorit: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    let name: String
    private(set) var serviceState: Driver<ServiceState> = .never()
    private(set) var basicInfo: Observable<PokemonBasicInfo>
    private(set) var pokemonImage: Observable<Data>
    
    // MARK: - Initializer
    init(name: String, url: String, interactor: PokemonDetailInteractorProtocol) {
        self.name = name
        self.interactor = interactor
        
        self.basicInfo = pokemonResponse
            .map { PokemonBasicInfo(id: $0.id,
                                    name: $0.name,
                                    type: $0.types)
            }
            .asObservable()
        
        self.pokemonImage = pokemonImageResponse.asObservable()
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
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Helpers
extension PokemonBasicDetailViewModel {
    
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

final class PokemonFullDetailViewModel: PokemonBasicDetailViewModel, PokemonFullDetailViewModelProtocol {
    
    private(set) var didTapFavorite: PublishSubject<Void> = .init()
    private(set) var typeinfoColor: Observable<UIColor> = .never()
    private(set) var bioInfo: Observable<PokemonBioInfo> = .never()
    private(set) var status: Observable<[Stat]> = .never()

    override init(name: String, url: String, interactor: PokemonDetailInteractorProtocol) {
        super.init(name: name, url: url, interactor: interactor)

        typeinfoColor = pokemonResponse
            .map { $0.types.map { $0.type.name.color()}.first }
            .unwrap()
            .asObservable()

        bioInfo = pokemonResponse
            .map { PokemonBioInfo(height: $0.height, weight: $0.weight) }
            .asObservable()

        status = pokemonResponse
            .map { $0.stats }
            .asObservable()
    }

}

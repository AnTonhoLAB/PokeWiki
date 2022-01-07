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
    var viewWillAppear: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var serviceState: Driver<Navigation<PokemonListAllViewModel.State>> { get }
}

final class PokemonListAllViewModel: PokemonListAllViewModelProtocol {
    
    typealias ServiceState = Navigation<State>
    let interactor: PokemonListAllInteractorProtocol
    
    init(interactor: PokemonListAllInteractorProtocol) {
        self.interactor = interactor
        self.serviceState = createServiceState()
    }
    
    // MARK: - Inputs
    let viewWillAppear: PublishSubject<Void> = .init()
    
    // MARK: - Outputs
    private(set) var serviceState: Driver<ServiceState> = .never()
    
    // MARK: - Internal methods
    private func createServiceState() -> Driver<ServiceState> {
            
        let activityIndicator = ActivityIndicator()
        
        let loadDebits = viewWillAppear
            .flatMapLatest { [weak self] _ -> Observable<ServiceState> in
                guard let self = self else { return .just(ServiceState(type: .connectionError)) }
                return self.interactor.fetchAll()
                    .trackActivity(activityIndicator)
                    .do(onNext: { (response) in
                        
                    })
                    .map { ServiceState(type: .success, info: $0) }
            }

        let loadingShown = activityIndicator
            .filter { $0 }
            .map { _ in ServiceState(type: .loading) }
            .asObservable()

        return Observable
            .merge(loadingShown, loadDebits)
            .asDriver(onErrorJustReturn: ServiceState(type: .connectionError))
    }
    
}


// MARK: - Helpers
extension PokemonListAllViewModel {
    
    // MARK: - State
    enum State: Equatable {
        case loading
        case success
        case connectionError
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

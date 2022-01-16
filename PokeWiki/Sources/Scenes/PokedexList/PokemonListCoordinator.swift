//
//  PokemonListCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 06/01/22.
//

import Foundation
import GGDevelopmentKit

class PokemonListCoordinator: GGCoordinator {
    
    init() {
        super.init(rootViewController: UINavigationController())
    }

    override func start() {
        let service = PokemonListAllService()
        let interactor = PokemonListAllInteractor(service: service)
        let viewModel = PokemonListAllViewModel(interactor: interactor)
        let listViewController = PokemonListViewController(viewModel: viewModel)
        
        viewModel.navigation
            .filter { $0.type == .openDetail}
            .map { $0.info as? PokemonItem }
            .unwrap()
            .drive(onNext:  { [openDetail] item in
                openDetail(item)
            })
            .disposed(by: listViewController.disposeBag)
        
        show(listViewController)
    }
    
    private func openDetail(for pokemonItem: PokemonItem) {
        PokemonDetailCoordinator(navigation: rootViewController, pokemonDetail: pokemonItem).start()
    }
}

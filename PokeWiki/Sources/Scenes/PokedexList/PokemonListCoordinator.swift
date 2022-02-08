//
//  PokemonListCoordinator.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 06/01/22.
//

import Foundation
import GGDevelopmentKit

class PokemonListCoordinator: GGCoordinator {
    
    let listViewController: PokemonListViewController
    let viewModel: PokemonListViewModelProtocol
    
    init(listViewController: PokemonListViewController, viewModel: PokemonListViewModelProtocol) {
        let navigation = UINavigationController()
        self.viewModel = viewModel
        self.listViewController = listViewController
        super.init(rootViewController: navigation)
    }

    override func start() {
        
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

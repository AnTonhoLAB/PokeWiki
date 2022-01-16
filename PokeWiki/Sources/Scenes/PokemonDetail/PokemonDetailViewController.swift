//
//  PokemonDetailViewController.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModelProtocol
    
    init(viewModel: PokemonDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

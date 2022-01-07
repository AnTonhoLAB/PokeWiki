//
//  ViewController.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 05/01/22.
//

import UIKit
import RxSwift

class PokemonListViewController: UIViewController {

    private let viewModel: PokemonListAllViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PokemonListAllViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        viewModel.serviceState
            .filter { $0.type == .success }
            .drive { object in
                print(object)
            }
            .disposed(by: disposeBag)
        
        viewModel.viewWillAppear
            .onNext(())
    }
}


//
//  ViewController.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 05/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import GGDevelopmentKit

class PokemonListViewController: UIViewController, UICollectionViewDelegateFlowLayout, GGAlerableViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PokemonListCell.self, forCellWithReuseIdentifier: PokemonListCell.identifier)
        
        return collectionView
    }()
    
    private let viewModel: PokemonListAllViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(viewModel: PokemonListAllViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureViews()
        
        setupRx()
        
        viewModel.serviceState
            .filter { $0.type == .loading }
            .drive { state in
                self.view.showLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.serviceState
            .filter { $0.type == .success }
            .drive { object in
                self.view.removeLoading()
            }
            .disposed(by: disposeBag)
        
        let reload: ( (UIAlertAction) -> Void) = { _ in
            print("aqui oi")
            self.viewModel.viewDidLoad.onNext(())
        }
        
        viewModel.serviceState
            .filter { $0.type == .error }
            .map { $0.info as? PokemonListError }
            .unwrap()
            .drive { object in
                self.view.removeLoading()
                self.alertSimpleMessage(message: "No connection") { _ in
                    print("aqui oi")
                    self.viewModel.viewDidLoad.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
//        viewModel.serviceState
//            .filter { $0.type == .error }
//            .drive { object in
//                self.view.removeLoading()
//                self.alertSimpleMessage(message: "No connection", action: reload)
//            }
//            .disposed(by: disposeBag)

        viewModel.viewDidLoad
            .onNext(())
    }
    
    // MARK: - Private methods
    private func setupRx() {
        viewModel
            .pokemonList
            .asObservable()
            .bind(to: collectionView.rx
                    .items(cellIdentifier: PokemonListCell.identifier,
                           cellType: PokemonListCell.self)) { row, pokemon, cell in
                let service = PokemonDetailService()
                let interactor = PokemonDetailInteractor(service: service)
                let viewModel = PokemonBasicDetailViewModel(name: pokemon.name, url: pokemon.url, interactor: interactor)
                cell.setup(viewModel: viewModel)
            }.disposed(by: disposeBag)
        
        collectionView
            .rx
            .modelSelected(PokemonItem.self)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: viewModel.didSelectItem)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .willDisplayLastCell
            .filter { $0 }
            .mapToVoid()
            .bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func configureViews() {
        self.collectionView.backgroundColor = .white
        self.view.backgroundColor = .white
    }
    
    // MARK: - Delegate methods
    private func setupConstraints() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}


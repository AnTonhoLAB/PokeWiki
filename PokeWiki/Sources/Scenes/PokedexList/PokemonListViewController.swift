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
import CoreData

class PokemonListViewController: UIViewController, UICollectionViewDelegateFlowLayout, GGAlertableViewController {
    
    private var bgImageView = UIImageView(image: #imageLiteral(resourceName: "ListBG"))
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PokemonListCell.self, forCellWithReuseIdentifier: PokemonListCell.identifier)
        
        return collectionView
    }()
    
    private var viewModel: PokemonListViewModelProtocol
    let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    init(viewModel: PokemonListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.updateUI = { //in
            self.bgImageView =  UIImageView(image: viewModel.titleText)
        }
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
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private methods
    private func setupRx() {
        viewModel
            .pokemonList
            .skip(1)
            .asObservable()
            .do(onNext: { [weak self] (pokemonResponse) in
                guard let self = self else { return }
                if pokemonResponse.count == 0 {
                    self.displayWarningInView(title: "oh no", message: "You don't have any Pokemon saved", buttonTitle: "Ok", action: nil)
                    self.bgImageView.isHidden = false
                }
            })
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
            .mapToFalse()
            .bind(to: viewModel.loadMore)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
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
    
        viewModel.serviceState
            .filter { $0.type == .error }
            .map { $0.info as? Error }
            .unwrap()
            .drive { [handle] error in
                self.view.removeLoading()
                handle(error)
            }
            .disposed(by: disposeBag)
        
        viewModel.viewDidLoad
            .onNext(true)
    }
    
    private func handle(error: Error) {
        let reload: (GGAlertAction) -> Void = { [weak self] _ in
            self?.viewModel
                .viewDidLoad
                .onNext(true)
        }

        let tryAgain = "Try again"

        if let listError = error as? PokemonListError {
            displayWarningInView(title: "oh no, an error occurred", message: listError.localizedDescription, buttonTitle: tryAgain, action: reload)
        } else {
            displayWarningInView(title: "Error", message: "An unexpected error occurred", buttonTitle: tryAgain, action: reload)
        }
    }
    
    private func setupViews() {
        view.addSubview(bgImageView)
        view.addSubview(collectionView)
    }
    
    private func configureViews() {
        self.bgImageView.isHidden = true
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = AppColors.bgColor
    }
    
    // MARK: - Delegate methods
    private func setupConstraints() {
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
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

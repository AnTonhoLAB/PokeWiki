//
//  PokemonDetailViewController.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 15/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import GGDevelopmentKit

final class PokemonDetailViewController: UIViewController, ViewCoded {
    
    // MARK: - Internal properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private let headerView =  PokemonHeaderDetailView(frame: .zero)
    private let bioIndoView = PokemonBioInfoView(frame: .zero)
    private let statsView = PokemonStatsView(frame: .zero)
    
    let disposeBag = DisposeBag()
    
    private let viewModel: PokemonFullDetailViewModelProtocol
   
    // MARK: - Initializers
    init(viewModel: PokemonFullDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupRx()
    }
    
    // MARK: - Private methods
    
    
    // MARK: - Setup methods
    private func setupRx() {
        viewModel.serviceState
            .filter { $0.type == .success }
            .drive { object in
                self.view.removeLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.serviceState
            .filter { $0.type == .loading }
            .drive { object in
                self.view.showLoading()
            }
            .disposed(by: disposeBag)
        
        viewModel.basicInfo
            .bind(to: headerView.rx.pokemonBasicInfo)
            .disposed(by: disposeBag)
        
        viewModel.pokemonImage
            .bind(to: headerView.pokemonImage
                    .rx
                    .imageData)
            .disposed(by: disposeBag)
        
        viewModel.bioInfo
            .bind(to: bioIndoView
                    .rx
                    .pokemonBasicInfo)
            .disposed(by: disposeBag)
        
        viewModel.typeinfoColor
            .bind(to: view.rx
                    .backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.status
            .bind(to: statsView.rx
                    .pokemonStatsInfo)
            .disposed(by: disposeBag)
        
        viewModel.alertMessage.subscribe(onNext: { message in
            switch message {
            case .added:
                self.headerView.favoriteButton.play()
            case .deleted:
                self.headerView.favoriteButton.stop()
            case .error:
                break
            }
        })
        .disposed(by: disposeBag)

        headerView.tapFavorite
            .bind(to: viewModel.didTapFavorite)
            .disposed(by: disposeBag)
        
        viewModel.viewWillAppear
            .onNext(())
    }
    
    internal func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(bioIndoView)
        stackView.addArrangedSubview(statsView)
    }
    
    internal func setupViewConfigs() {
        self.view.backgroundColor = .white
    }
    
    internal func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//
//  PokemonListCell.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import UIKit
import RxSwift

class PokemonListCell: UICollectionViewCell {
    private let nameLabel: UILabel = UILabel(frame: .zero)
    
    // MARK: - Static variables
    static let identifier = "PokemonListCell"
    
    // MARK: - Private properties
    private var disposeBag = DisposeBag()
    
    // MARK: - Initializers
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Public methods
    func setup(viewModel: PokemonListCellViewModelProtocol) {
        viewModel.viewWillAppear.onNext(())
        
        viewModel.pokemonDetail.drive { [weak self] (detail) in
            guard let self = self else { return }
            self.nameLabel.text = detail.name
            self.backgroundColor = detail.types.first?.type.name.color()
        }.disposed(by: disposeBag)
        
        viewModel.serviceState
            .filter { $0.type == .success }
            .drive { object in
            }
            .disposed(by: disposeBag)

        viewModel.viewWillAppear
            .onNext(())
    }
    
    // MARK: - Private methods
    private func setupViews() {
        self.addSubview(self.nameLabel)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        self.nameLabel.text = ""
        disposeBag = DisposeBag()
    }
}

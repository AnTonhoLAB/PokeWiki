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
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    
    func setup(viewModel: PokemonListCellViewModelProtocol) {
        self.nameLabel.text = viewModel.name
        viewModel.viewWillAppear.onNext(())
        
        viewModel.pokemonDetail.drive { (detail) in
            self.backgroundColor = detail.types.first?.type.name.color()
        }.disposed(by: disposeBag)

        
        viewModel.serviceState
            .filter { $0.type == .success }
            .drive { object in
                print(object)
            }
            .disposed(by: disposeBag)

        viewModel.viewWillAppear
            .onNext(())
    }
    
    private func setupViews() {
        self.addSubview(self.nameLabel)
        self.backgroundColor = .blue
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}

//
//  PokemonListCell.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import UIKit
import RxSwift

class PokemonListCell: UICollectionViewCell {
    
    // MARK: - Static variables
    static let identifier = "PokemonListCell"
    
    // MARK: - Private properties
    private let imageBG = UIImageView(image: #imageLiteral(resourceName: "BGCardNeutral").withRenderingMode(.alwaysTemplate))
    private let imageHLBG = UIImageView(image: #imageLiteral(resourceName: "highLightBG"))
    private let nameLabel: UILabel = UILabel(frame: .zero)
    
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
            self.imageBG.tintColor = detail.types.first?.type.name.color()
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
        imageBG.addSubview(self.nameLabel)
        addSubview(imageBG)
        addSubview(imageHLBG)
        nameLabel.font = UIFont(name: "GillSans-Bold", size: 17)
        nameLabel.numberOfLines = 2
        
        imageBG.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageBG.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageBG.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        imageBG.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imageBG.translatesAutoresizingMaskIntoConstraints = false
        
        imageHLBG.topAnchor.constraint(equalTo: imageBG.topAnchor).isActive = true
        imageHLBG.bottomAnchor.constraint(equalTo: imageBG.bottomAnchor, constant: -35).isActive = true
        imageHLBG.trailingAnchor.constraint(equalTo: imageBG.trailingAnchor).isActive = true
        imageHLBG.leadingAnchor.constraint(equalTo: imageBG.leadingAnchor, constant: 24).isActive = true
        imageHLBG.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        
        nameLabel.bottomAnchor.constraint(equalTo: imageBG.bottomAnchor, constant: -8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: imageBG.trailingAnchor, constant: -5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageBG.leadingAnchor, constant: 5).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        self.imageBG.tintColor = .white
        self.nameLabel.text = ""
        disposeBag = DisposeBag()
    }
}

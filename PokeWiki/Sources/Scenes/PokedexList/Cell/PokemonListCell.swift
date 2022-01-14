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
    private let pokemonImage = UIImageView(frame: .zero)
    private let nameLabel: UILabel = UILabel(frame: .zero)
    private let numberLabel: UILabel = UILabel(frame: .zero)
    private let font = UIFont(name: "GillSans-Bold", size: 17)
    
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
            self?.nameLabel.text = detail.name
            self?.numberLabel.text = "#\(detail.id)"
            self?.imageBG.tintColor = detail.types.first?.type.name.color()
        }.disposed(by: disposeBag)
        
        viewModel.pokemonImage.drive { [weak self] (image) in
            self?.pokemonImage.image = UIImage(data: image)
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
        imageBG.addSubview(nameLabel)
        imageBG.addSubview(numberLabel)
        addSubview(imageBG)
        addSubview(imageHLBG)
        imageHLBG.addSubview(pokemonImage)
        
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

        pokemonImage.contentMode = .scaleAspectFill
        pokemonImage.topAnchor.constraint(equalTo: imageHLBG.topAnchor, constant: -20).isActive = true
        pokemonImage.bottomAnchor.constraint(equalTo: imageHLBG.bottomAnchor).isActive = true
        pokemonImage.trailingAnchor.constraint(equalTo: imageHLBG.trailingAnchor, constant: 15).isActive = true
        pokemonImage.leadingAnchor.constraint(equalTo: imageHLBG.leadingAnchor, constant: 5).isActive = true
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = font
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.bottomAnchor.constraint(equalTo: imageBG.bottomAnchor, constant: -8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: imageBG.trailingAnchor, constant: -5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageBG.leadingAnchor, constant: 5).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.font = font
        numberLabel.textAlignment = .left
        numberLabel.textColor = .white
        numberLabel.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: imageBG.trailingAnchor, constant: -10).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: imageBG.leadingAnchor, constant: 10).isActive = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        self.imageBG.tintColor = .white
        self.pokemonImage.image = nil
        self.nameLabel.text = ""
        self.numberLabel.text = ""
        disposeBag = DisposeBag()
    }
}

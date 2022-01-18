//
//  PokemonHeaderDetailView.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 17/01/22.
//

import GGDevelopmentKit
import RxSwift

class PokemonHeaderDetailView: UIView, ViewCoded {
    
    
    
    // MARK: - Private properties
    private let font = UIFont(name: "GillSans-Bold", size: 26)
    private var disposeBag = DisposeBag()
    
    // MARK: - Public properties
    private(set) var imageHLBG = UIImageView(image: #imageLiteral(resourceName: "HeaderBG"))
    private(set) var pokemonImage = UIImageView(frame: .zero)
    private(set) var nameLabel: UILabel = UILabel(frame: .zero)
    private(set) var numberLabel: UILabel = UILabel(frame: .zero)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    // MARK: - Private methods
    func setupViews() {
        addSubview(nameLabel)
        addSubview(numberLabel)
        addSubview(imageHLBG)
        imageHLBG.addSubview(pokemonImage)
        
        imageHLBG.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageHLBG.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageHLBG.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageHLBG.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageHLBG.translatesAutoresizingMaskIntoConstraints = false

        pokemonImage.contentMode = .scaleAspectFit
        pokemonImage.topAnchor.constraint(equalTo: imageHLBG.topAnchor, constant: 17).isActive = true
        pokemonImage.leadingAnchor.constraint(equalTo: imageHLBG.leadingAnchor, constant: 70).isActive = true
        pokemonImage.trailingAnchor.constraint(equalTo: imageHLBG.trailingAnchor, constant: -70).isActive = true
        pokemonImage.heightAnchor.constraint(equalToConstant: 220).isActive = true
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -54).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupViewConfigs() {
        nameLabel.font = font
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        
        numberLabel.font = font
        numberLabel.textAlignment = .left
        numberLabel.textColor = .white
    }
    
    func setupConstraints() {
        
    }
}

extension Reactive where Base: PokemonHeaderDetailView {

    var pokemonBasicInfo: Binder<PokemonBasicInfo> {
        return Binder(self.base) { view, detail in
            view.nameLabel.text = detail.name
            view.numberLabel.text = "#\(detail.id)"
        }
    }
}

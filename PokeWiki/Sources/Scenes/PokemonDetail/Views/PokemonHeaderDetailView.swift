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
    private(set) var typesStack: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    
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
        addSubview(typesStack)
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
        nameLabel.heightAnchor.constraint(equalToConstant: 26).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        typesStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        typesStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        typesStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        typesStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        typesStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 22).isActive = true
        typesStack.translatesAutoresizingMaskIntoConstraints = false
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
    
    fileprivate func createBadges(with types: [TypeElement] ) {
        types.forEach { element in
            let typeContentView = UIView(frame: .zero)
            let typeBadgeView = UIView(frame: .zero)
            let typeLabel = UILabel(frame: .zero)
            
            
            typeBadgeView.layer.cornerRadius = 12
            typeBadgeView.layer.masksToBounds = true
            
            typeContentView.addSubview(typeBadgeView)
            typeBadgeView.addSubview(typeLabel)
            
            
            typeBadgeView.backgroundColor = element.type.name.color()
            typeLabel.text = element.type.name.rawValue
            typeLabel.textAlignment = .center
            
            let font = UIFont(name: "GillSans-Bold", size: 22)
            typeLabel.font = font
            typeLabel.textColor = .white
            
            typeBadgeView.widthAnchor.constraint(equalToConstant: 132).isActive = true
            typeBadgeView.translatesAutoresizingMaskIntoConstraints = false
            
            typeLabel.topAnchor.constraint(equalTo: typeBadgeView.topAnchor, constant: 3).isActive = true
            typeLabel.leadingAnchor.constraint(equalTo: typeBadgeView.leadingAnchor, constant: 3).isActive = true
            typeLabel.trailingAnchor.constraint(equalTo: typeBadgeView.trailingAnchor, constant: 3).isActive = true
            typeLabel.bottomAnchor.constraint(equalTo: typeBadgeView.bottomAnchor, constant: -5).isActive = true
            typeLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            typeBadgeView.topAnchor.constraint(equalTo: typeContentView.topAnchor).isActive = true
            typeBadgeView.bottomAnchor.constraint(equalTo: typeContentView.bottomAnchor).isActive = true
            typeBadgeView.centerXAnchor.constraint(equalTo: typeContentView.centerXAnchor).isActive = true
            typeBadgeView.translatesAutoresizingMaskIntoConstraints = false
            
            typeContentView.widthAnchor.constraint(equalToConstant: frame.width / CGFloat(types.count)).isActive = true
            typeContentView.translatesAutoresizingMaskIntoConstraints = false
           
            
            typesStack.addArrangedSubview(typeContentView)
        }
    }
}

extension Reactive where Base: PokemonHeaderDetailView {

    var pokemonBasicInfo: Binder<PokemonBasicInfo> {
        return Binder(self.base) { view, detail in
            view.nameLabel.text = detail.name
            view.numberLabel.text = "#\(detail.id)"
            view.createBadges(with: detail.type)
        }
    }
}

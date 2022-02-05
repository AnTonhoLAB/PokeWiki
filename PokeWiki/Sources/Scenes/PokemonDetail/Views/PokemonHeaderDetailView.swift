//
//  PokemonHeaderDetailView.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 17/01/22.
//

import GGDevelopmentKit
import RxSwift
import Lottie

enum HeaderAnimations: String {
    case favoriteAnimation
    case favoriteAnimationB
}

class PokemonHeaderDetailView: UIView, ViewCoded {
    
    // MARK: - Private properties
    private let font = UIFont(name: "GillSans-Bold", size: 30)
    
    // MARK: - Public properties
    private let imageHLBG = UIImageView(image: #imageLiteral(resourceName: "HeaderBG"))
    let favoriteButton = AnimatedLottieButton(name: HeaderAnimations.favoriteAnimationB.rawValue, frame: .zero)
    private(set) var pokemonImage = UIImageView(frame: .zero)
    fileprivate let nameLabel: UILabel = UILabel(frame: .zero)
    fileprivate let numberLabel: UILabel = UILabel(frame: .zero)
    private let typesStack: UIStackView = {
        $0.axis = .horizontal
        return $0
    }(UIStackView())
    let bag = DisposeBag()
    
    private(set) var tapFavorite: Observable<Void>
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        self.tapFavorite = favoriteButton.rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .asObservable()
        
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
        addSubview(favoriteButton)
        imageHLBG.addSubview(pokemonImage)
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
        
        favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 85).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 85).isActive = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        typesStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12).isActive = true
        typesStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        typesStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        typesStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9).isActive = true
        typesStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 33).isActive = true
        typesStack.translatesAutoresizingMaskIntoConstraints = false
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
            
            typeLabel.topAnchor.constraint(equalTo: typeBadgeView.topAnchor).isActive = true
            typeLabel.leadingAnchor.constraint(equalTo: typeBadgeView.leadingAnchor, constant: 3).isActive = true
            typeLabel.trailingAnchor.constraint(equalTo: typeBadgeView.trailingAnchor, constant: 3).isActive = true
            typeLabel.bottomAnchor.constraint(equalTo: typeBadgeView.bottomAnchor).isActive = true
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            typeBadgeView.topAnchor.constraint(equalTo: typeContentView.topAnchor).isActive = true
            typeBadgeView.bottomAnchor.constraint(equalTo: typeContentView.bottomAnchor).isActive = true
            typeBadgeView.centerXAnchor.constraint(equalTo: typeContentView.centerXAnchor).isActive = true
            typeBadgeView.translatesAutoresizingMaskIntoConstraints = false
            typeBadgeView.heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            typeContentView.widthAnchor.constraint(equalToConstant:( (frame.width - 60) / CGFloat(types.count)) ).isActive = true
            typeContentView.translatesAutoresizingMaskIntoConstraints = false
           
            typesStack.addArrangedSubview(typeContentView)
        }
    }
}

extension Reactive where Base: PokemonHeaderDetailView {

    var pokemonBasicInfo: Binder<PokemonBasicInfo> {
        return Binder(self.base) { view, detail in
            view.nameLabel.text = detail.name.capitalized
            view.numberLabel.text = "#\(detail.id)"
            view.createBadges(with: detail.type)
        }
    }
}

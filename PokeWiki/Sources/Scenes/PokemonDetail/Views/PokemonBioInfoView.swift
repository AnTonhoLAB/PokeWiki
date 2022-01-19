//
//  PokemonBioInfoView.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 18/01/22.
//

import GGDevelopmentKit
import RxSwift

class PokemonBioInfoView: UIView, ViewCoded {
    
    // MARK: - Private properties
    private let font = UIFont(name: "GillSans-Bold", size: 26)
    private let titleFont = UIFont(name: "GillSans-Bold", size: 16)
    private let infoFont =  UIFont(name: "GillSans-Regular", size: 16)
    private var disposeBag = DisposeBag()
    
    // MARK: - Public properties
    private(set) var heightTextLabel: UILabel = UILabel(frame: .zero)
    private(set) var heightValueLabel: UILabel = UILabel(frame: .zero)
    private(set) var weightTextLabel: UILabel = UILabel(frame: .zero)
    private(set) var weightValueLabel: UILabel = UILabel(frame: .zero)
    private var bioInfoStack: UIStackView = {
        $0.axis = .horizontal
        $0.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 1, alpha: 0.2417441647)
        return $0
    }(UIStackView())
    private var heighStack: UIStackView = {
        $0.axis = .vertical
        return $0
    }(UIStackView())
    private var weighStack: UIStackView = {
        $0.axis = .vertical
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
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2879525528)
        self.heightAnchor.constraint(equalToConstant: 108).isActive = true

        addSubview(bioInfoStack)
        bioInfoStack.addArrangedSubview(heighStack)
        bioInfoStack.addArrangedSubview(weighStack)
        
        heighStack.addArrangedSubview(heightTextLabel)
        heighStack.addArrangedSubview(heightValueLabel)
        
        weighStack.addArrangedSubview(weightTextLabel)
        weighStack.addArrangedSubview(weightValueLabel)
    }
    
    func setupViewConfigs() {
        
        bioInfoStack.layer.cornerRadius = 20
        bioInfoStack.layer.masksToBounds = true
        
        heightTextLabel.text = "height"
        heightTextLabel.textAlignment = .center
        heightTextLabel.font = titleFont
        heightTextLabel.textColor = .white
        
        weightTextLabel.text = "weight"
        weightTextLabel.textAlignment = .center
        weightTextLabel.font = titleFont
        weightTextLabel.textColor = .white
        
        heightValueLabel.textAlignment = .center
        heightValueLabel.font = infoFont
        heightValueLabel.textColor = .white
        
        weightValueLabel.textAlignment = .center
        weightValueLabel.font = infoFont
        weightValueLabel.textColor = .white
        
    }
    
    func setupConstraints() {
        bioInfoStack.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        bioInfoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        bioInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        bioInfoStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        heighStack.widthAnchor.constraint(equalTo: weighStack.widthAnchor).isActive = true
        bioInfoStack.translatesAutoresizingMaskIntoConstraints = false
        
        heightTextLabel.heightAnchor.constraint(equalTo: heightValueLabel.heightAnchor).isActive = true
        heightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        heightValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bioInfoStack.isLayoutMarginsRelativeArrangement = true
        bioInfoStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        weightTextLabel.heightAnchor.constraint(equalTo: weightValueLabel.heightAnchor).isActive = true
        weightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        weightValueLabel.translatesAutoresizingMaskIntoConstraints = false
       
    }
}

extension Reactive where Base: PokemonBioInfoView {

    var pokemonBasicInfo: Binder<PokemonBioInfo> {
        return Binder(self.base) { view, detail in
            view.heightValueLabel.text = "\((detail.height/10).stringWithoutZeroFraction) m"
            view.weightValueLabel.text = "\((detail.weight/10).stringWithoutZeroFraction) kg"
        }
    }
}


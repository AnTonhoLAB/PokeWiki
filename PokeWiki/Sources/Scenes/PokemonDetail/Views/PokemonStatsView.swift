//
//  PokemonStatsView.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 19/01/22.
//

import GGDevelopmentKit
import RxSwift

class PokemonStatsView: UIView, ViewCoded {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupViews() {
        // TODO: - setupViews
    }
    
    func setupViewConfigs() {
        backgroundColor = .red
    }
    
    func setupConstraints() {
        
        self.heightAnchor.constraint(equalToConstant: 500).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

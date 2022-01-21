//
//  PokemonStatsView.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 19/01/22.
//

import GGDevelopmentKit
import RxSwift

class PokemonStatsView: UIView, ViewCoded {
    
    private var statsStack: UIStackView = {
        $0.axis = .vertical
        $0.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 1, alpha: 0.2417441647)
        return $0
    }(UIStackView())
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setup(stats: [Stat]) {
        stats.forEach { stat in
            
            let chart = GGSimpleBarChart(frame: .zero)
            chart.setup(value: stat.baseStat, from: 250)
            chart.heightAnchor.constraint(equalToConstant: 20).isActive = true
            statsStack.addSubview(chart)
        }
    }
    
    // MARK: - Setup layout
    func setupViews() {
        addSubview(statsStack)
    }
    
    func setupViewConfigs() {
        
    }
    
    func setupConstraints() {
        
        self.heightAnchor.constraint(equalToConstant: 500).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension Reactive where Base: PokemonStatsView {

    var pokemonStatsInfo: Binder<[Stat]> {
        return Binder(self.base) { view, stats in
            view.setup(stats: stats)
        }
    }
}

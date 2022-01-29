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
        $0.spacing = 0
        $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.04415166945)
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
        
        let charts = stats.map { stat ->  (Stat, GGSimpleBarChart) in
            let chart = createChart(stat: stat)
            return (stat, chart)
        }
        
        for chart in charts {
            statsStack.addArrangedSubview(chart.1)
        }
        
        for chart in charts {
            if let statName = chart.0.stat.statName {
                chart.1.setup(nameStatus: chart.0.stat.name, value: chart.0.baseStat, from: 250, chartColor: statName.getColor())
            } else {
                chart.1.setup(nameStatus: chart.0.stat.name, value: chart.0.baseStat, from: 250)
            }
        }
    }
    
    private func createChart(stat: Stat) -> GGSimpleBarChart {
        let chart = GGSimpleBarChart(frame: .zero)
        chart.heightAnchor.constraint(equalToConstant: 42).isActive = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }
    
    // MARK: - Setup layout
    func setupViews() {
        addSubview(statsStack)
    }
    
    func setupViewConfigs() {
        
    }
    
    func setupConstraints() {
        statsStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        statsStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        statsStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        statsStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        statsStack.isLayoutMarginsRelativeArrangement = true
        statsStack.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 20)

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

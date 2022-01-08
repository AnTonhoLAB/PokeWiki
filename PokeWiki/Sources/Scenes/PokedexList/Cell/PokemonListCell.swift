//
//  PokemonListCell.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 07/01/22.
//

import UIKit

class PokemonListCell: UICollectionViewCell {
    private let nameLabel: UILabel = UILabel(frame: .zero)
    
    // MARK: - Static variables
    static let identifier = "PokemonListCell"
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {  fatalError("init(coder:) has not been implemented") }
    
    func setup(name: String) {
        self.nameLabel.text = name
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

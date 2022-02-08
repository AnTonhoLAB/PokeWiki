//
//  AnimatedLottieButton.swift
//  PokeWiki
//
//  Created by George Vilnei Arboite Gomes on 04/02/22.
//

import Lottie
import RxSwift
import RxCocoa
import GGDevelopmentKit

class AnimatedLottieButton: UIButton, ViewCoded {
    
    let lottieView = AnimationView(frame: .zero)
    
    // MARK: - Initializers
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        lottieView.animation = Animation.named(name)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func play() {
        lottieView.play()
    }
    
    func stop() {
        lottieView.stop()
    }
    
    func full(with frame: CGFloat) {
        lottieView.play(fromFrame: frame, toFrame: frame)
    }
    
    // MARK: - Setup layout
    func setupViews() {
        addSubview(lottieView)
    }
    
    func setupViewConfigs() {
        lottieView.isUserInteractionEnabled = false
        lottieView.contentMode = .scaleToFill
    }
    
    func setupConstraints() {
        lottieView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        lottieView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lottieView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lottieView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lottieView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension Reactive where Base: AnimatedButton {

    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        controlEvent(.touchUpInside)
    }
}

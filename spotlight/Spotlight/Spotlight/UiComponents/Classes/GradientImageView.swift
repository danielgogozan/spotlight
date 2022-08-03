//
//  GradientImageView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 24.02.2022.
//

import Foundation
import UIKit

class GradientImageView: UIImageView {
    
    private let gradientLayer = CAGradientLayer()
    
    var colors: [UIColor] = [.red]
    
    init(image: UIImage?, colors: [UIColor]) {
        self.colors = colors
        super.init(image: image)
        clipsToBounds = true
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        gradientLayer.colors = colors.map { $0.cgColor }
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setup(image: UIImage?, colors: [UIColor]) {
        self.colors = colors
        self.image = image
        clipsToBounds = true
        commonInit()
    }
}

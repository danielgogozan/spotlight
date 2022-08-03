//
//  SButton.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

@IBDesignable
class SButton: UIButton {
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var variesByIsEnabled: Bool = false
    
    override var isEnabled: Bool {
        didSet {
            guard variesByIsEnabled else { return }
            if isEnabled {
                self.layer.sublayers?.remove(at: 0)
                self.applyGradient(colours: enabledGradientColors)
            } else {
                self.layer.sublayers?.remove(at: 0)
                self.applyGradient(colours: disabledGradientColors)
            }
        }
    }
    
    var enabledGradientColors: [UIColor] = [Asset.Colors.primary.color, Asset.Colors.redish.color]
    var disabledGradientColors: [UIColor] = [Asset.Colors.lightGray2.color, Asset.Colors.lightGray.color]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}

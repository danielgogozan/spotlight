//
//  UIButton+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 18.02.2022.
//

import UIKit

extension UIButton {
    func pulsingAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.8
        pulse.toValue = 1.0
        layer.add(pulse, forKey: "pulse")
    }
}

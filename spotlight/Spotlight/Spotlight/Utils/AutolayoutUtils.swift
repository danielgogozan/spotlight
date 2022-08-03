//
//  Autolayout.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import Foundation
import UIKit

extension UIView {

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }

        if let superviewBottom = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottom, constant: -padding.bottom).isActive = true
        }

        if let superviewLeading = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeading, constant: padding.left).isActive = true
        }

        if let superviewTrailing = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailing, constant: -padding.right).isActive = true
        }
    }

    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterX).isActive = true
        }

        if let superviewCenterY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterY).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterX).isActive = true
        }
    }

    func constrainWidth(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }

    func constrainHeight(constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
}

//
//  UIView+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 11.03.2022.
//

import UIKit

// MARK: - Load from nib
extension UIView {
    
    func nibView<T>(for: T.Type) -> UIView? {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    @discardableResult
    func loadNib<T>(from: T.Type) -> UIView? {
        guard let nibView = nibView(for: T.self) else { return nil }
        addSubview(nibView)
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return nibView
    }
    
}

// MARK: - Customization
extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addBlurEffect(blurEffectStyle: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurView, at: 0)
    }
    
    func apply(style: ViewStyle) {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        layer.shadowRadius = style.shadowRadius ?? 0.0
        layer.shadowOffset = style.shadowOffset ?? .zero
        layer.shadowOpacity = style.shadowOpacity ?? 0.0
        layer.shadowColor = style.shadowColor?.cgColor
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

// MARK: Toast
extension UIView {
    func showToast(with message: String, color: UIColor) {
        let toastView = UIStackView()
        toastView.axis = .vertical
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.isLayoutMarginsRelativeArrangement = true
        toastView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = message
        label.font = FontFamily.Nunito.semiBold.font(size: 12)
        label.textColor = .white
        
        toastView.backgroundColor = color
        toastView.layer.cornerRadius = 10
        toastView.addArrangedSubview(label)
        
        self.addSubview(toastView)
        NSLayoutConstraint.activate([
            toastView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            toastView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            toastView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            toastView.trailingAnchor.constraint(greaterThanOrEqualTo: self.trailingAnchor, constant: 20)
        ])
        
        toastView.alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, animations: {
            toastView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, animations: {
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        })
        
    }
}

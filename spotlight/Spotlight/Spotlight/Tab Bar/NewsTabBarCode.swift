//
//  FloatinView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

class NewsTabBarCode: UIView {

    weak var delegate: CustomTabBarDelegate?

    var tabControls: [(button: UIButton, label: UILabel)] = []
    var tabsStackView: [UIStackView] = []

    init() {
        super.init(frame: .zero)
        backgroundColor = .white

        setupStackView()
        updateUI(selectedIndex: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowRadius = bounds.height / 2
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowColor = Asset.Colors.black.color.cgColor
    }

    func setupStackView() {
        let stackView = UIStackView()
        TabBarButton.allCases.forEach { tab in
            let button = createButton(image: tab.image, selectedImage: tab.selectedImage, index: tab.rawValue)
            let label = createLabel(title: tab.title)
            let tabstack = createTabStackView(views: [button, label])
            
            tabControls.append((button: button, label: label))
            tabsStackView.append(tabstack)
            stackView.addArrangedSubview(tabstack)
        }
        
        stackView.spacing = 40
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    private func createButton(image: UIImage, selectedImage: UIImage, index: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = index
        button.setImage(image, for: .normal)
        button.setImage(image.withColor(Asset.Colors.primary.color), for: .selected)
        button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
        button.tintColor = .green
        button.constrainWidth(constant: 55)
        return button
    }
    
    private func createLabel(title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(font: FontFamily.Nunito.regular, size: 10)
        titleLabel.textColor = Asset.Colors.gray.color
        return titleLabel
    }
    
    private func createTabStackView(views: [UIView]) -> UIStackView {
        let hStackView = UIStackView(arrangedSubviews: views)
        hStackView.axis = .vertical
        hStackView.spacing = 3
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tChange(_:))))
        hStackView.isUserInteractionEnabled = true
        return hStackView
    }
}

// MARK: - Tap gestures & UI updates
extension NewsTabBarCode {
    @objc
    func tChange(_ sender: UITapGestureRecognizer) {
        guard let selectedTabStack = tabsStackView.first(where: { sender.view?.isDescendant(of: $0) ?? false  }) else { return }
        if let button = selectedTabStack.subviews[0] as? UIButton {
            changeTab(button)
        }
    }
    
    @objc
    func changeTab(_ sender: UIButton) {
        sender.pulsingAnimation()
        delegate?.didSelect(index: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }

    func updateUI(selectedIndex: Int) {
        for (index, control) in tabControls.enumerated() {
            if index == selectedIndex {
                control.button.isSelected = true
                control.label.textColor = Asset.Colors.black.color
            } else {
                control.button.isSelected = false
                control.label.textColor = Asset.Colors.gray.color
            }
        }
    }
    
    func toggle(hide: Bool) {
        if hide == isHidden {
            return
        }
        
        if !hide {
            isHidden = hide
        }
    
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.6,
            options: .transitionCrossDissolve,
            animations: {
                self.alpha = hide ? 0 : 1
                self.transform = hide ? CGAffineTransform(translationX: 0, y: 50) : .identity
            },
            completion: { _ in
                if hide {
                    self.isHidden = hide
                }
            })
    }
}

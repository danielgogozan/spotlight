//
//  NewsTabBar.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit
 
/**
 This is not working for some reason. Further investigation needed. As replacement NewsTabBarCode was used
 */
class NewsTabBar: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var containerStackView: UIStackView!
    private var buttons: [UIButton] = []
    
    weak var delegate: CustomTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = .zero
        layer.shadowRadius = bounds.height / 2
    }
    
    private func loadFromNib() {
        loadNib(from: NewsTabBar.self)
        
        self.backgroundColor = .green
        
        TabBarButton.allCases.forEach { tab in
            let button = createButton(image: tab.image, selectedImage: tab.selectedImage, title: tab.title, index: tab.rawValue)
            buttons.append(button)
            containerStackView.addArrangedSubview(button)
        }
        
        updateUI(selectedIndex: 0)
    }
    
    private func createButton(image: UIImage, selectedImage: UIImage, title: String, index: Int) -> UIButton {
        let button = UIButton()
        button.tag = index
        button.setImage(image, for: .normal)
        button.setImage(image.withColor(Asset.Colors.primary.color), for: .selected)
        button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc
    func changeTab(_ sender: UIButton) {
        sender.pulsingAnimation()
        delegate?.didSelect(index: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }
    
    func updateUI(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                button.tintColor = Asset.Colors.primary.color
            } else {
                button.isSelected = false
                button.tintColor = .gray
            }
        }
    }
}

protocol CustomTabBarDelegate: AnyObject {
    func didSelect(index: Int)
}

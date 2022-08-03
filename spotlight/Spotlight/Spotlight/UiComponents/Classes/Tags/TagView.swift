//
//  TagView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 24.02.2022.
//

import Foundation
import UIKit

class TagView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var tagLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private let gradient: CAGradientLayer = CAGradientLayer()
    
    var onTagSelected: ((Bool) -> Void)?

    var isSelected = false {
        didSet {
           updateBasedOnSelection()
        }
    }
    
    var tagName: String = "" {
        didSet {
            tagLabel.text = tagName
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.isHidden = false
            self.imageView.image = isSelected ? image?.withColor(.white) : image?.withColor(Asset.Colors.black.color)
        }
    }

    var isDeselectable = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = bounds.height / 2
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = Asset.Colors.searchBorder.color.cgColor
    }
    
    private func commonInit() {
        loadNib(from: TagView.self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTagSelect(_:)))
        contentView.addGestureRecognizer(tapGesture)
        // This is mandatory, otherwise the tapGesture will override methods like "didSelectItemAt" of Table/Collection View
        tapGesture.cancelsTouchesInView = false
        
        contentView.clipsToBounds = true
        
        tagLabel.font = FontFamily.Nunito.regular.font(size: 13)
        tagLabel.textColor = Asset.Colors.black.color
        
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: contentView.layer.frame.size.width, height: contentView.layer.frame.size.width)
    }

    @objc
    private func onTagSelect(_ sender: Any?) {
        if isSelected && !isDeselectable {
            onTagSelected?(isSelected)
            return
        }
        
        isSelected.toggle()
        updateBasedOnSelection()
        onTagSelected?(isSelected)
    }
    
    private func updateBasedOnSelection() {
        tagLabel.textColor = isSelected ? .white : Asset.Colors.black.color
        if isSelected {
            gradient.colors = [Asset.Colors.primary.color.cgColor, UIColor.white.cgColor]
            if !(contentView.layer.sublayers?.contains(where: { $0 == gradient }) ?? false) {
                contentView.layer.insertSublayer(gradient, at: 0)
            }
            imageView.image =  self.imageView.image?.withColor(.white)
        } else {
            gradient.colors = [UIColor.white.cgColor]
            imageView.image =  self.imageView.image?.withColor(Asset.Colors.black.color)
        }
    }
    
    func reset() {
        isSelected = false
        tagLabel.textColor = Asset.Colors.black.color
        gradient.colors = [UIColor.white.cgColor]
        imageView.image = nil
        imageView.isHidden = true
    }
    
}

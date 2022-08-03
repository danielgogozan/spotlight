//
//  SocialMediaView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

@IBDesignable
class SocialMediaView: UIView {
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 20)
        return stackView
    }()
    private lazy var imageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var socialMediaLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.Nunito.light.font(size: 15)
        label.textColor = Asset.Colors.black.color
        label.textAlignment = .left
        return label
    }()
    
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
        
        shadowView.layer.cornerRadius = shadowView.frame.height / 2
        shadowView.layer.borderColor = UIColor.lightGray.cgColor
        shadowView.layer.borderWidth = 0.2
    }
    
    @IBInspectable
    var image: UIImage = Asset.Images.email.image {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable
    var socialMediaName: String = "" {
        didSet {
            socialMediaLabel.text = socialMediaName
        }
    }
    
}

private extension SocialMediaView {
    func commonInit() {
        addViews()
        addConstraints()
        customizeView()
    }
    
    func addViews() {
        self.addSubview(shadowView)
        self.addSubview(containerStackView)
        containerStackView.addArrangedSubview(imageContainer)
        containerStackView.addArrangedSubview(socialMediaLabel)
        
        imageContainer.addSubview(imageView)
        imageContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: self.topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            containerStackView.rightAnchor.constraint(equalTo: shadowView.rightAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: -5),
            
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func customizeView() {
        shadowView.layer.shadowColor = Asset.Colors.black.color.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowRadius = 1
    }
}

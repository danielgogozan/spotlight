//
//  LoginBottomView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

class LoginBottomView: UIView {
    // MARK: - Private properties
    @IBOutlet private weak var contentStackView: UIStackView!
    @IBOutlet private weak var socialMediaStackView: UIStackView!
    @IBOutlet private weak var faceImageContainer: UIView!
    @IBOutlet private weak var faceImageView: UIImageView!
    @IBOutlet private weak var faceLabel: UILabel!
    @IBOutlet private weak var connectLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

private extension LoginBottomView {
    func commonInit() {
        loadNib(from: LoginBottomView.self)
        faceLabel.font = FontFamily.Nunito.regular.font(size: 14)
        connectLabel.font = FontFamily.Nunito.regular.font(size: 14)
        faceImageView.image = Asset.Images.faceid.image.withColor(.lightGray)
        faceImageContainer.layer.borderWidth = 1
        faceImageContainer.layer.borderColor = Asset.Colors.redish.color.cgColor
        faceImageContainer.layer.cornerRadius = 5
        
        addSocialMediaViews()
    }
    
    func addSocialMediaViews() {
        SocialMedia.allCases.forEach { socialMedia in
            let socialMediaView = SocialMediaView()
            socialMediaView.image = socialMedia.icon
            socialMediaView.socialMediaName = L10n.loginWith(socialMedia.name)
            socialMediaStackView.addArrangedSubview(socialMediaView)
        }
    }
}

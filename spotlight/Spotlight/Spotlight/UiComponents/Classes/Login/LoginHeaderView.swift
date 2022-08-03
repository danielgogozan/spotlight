//
//  LoginHeaderView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

class LoginHeaderView: UIView {
    
    // MARK: - Private properties
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
}

// MARK: - Private API
private extension LoginHeaderView {
    func commonInit() {
        loadNib(from: LoginHeaderView.self)
        titleLabel.text = L10n.loginTitle
        titleLabel.font = FontFamily.Nunito.semiBold.font(size: 24)
        titleLabel.textColor = Asset.Colors.primary.color
        
        infoLabel.text = L10n.loginInfo
        infoLabel.font = FontFamily.Nunito.regular.font(size: 16)
        infoLabel.attributedText = infoLabelAttributedString()
    }
    
    func infoLabelAttributedString() -> NSMutableAttributedString {
        let message = L10n.loginInfo
        let bodyAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.light.font(size: 14),
                                                             .foregroundColor: Asset.Colors.black.color]

        let linkAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.light.font(size: 14),
                                                                .foregroundColor: Asset.Colors.secondary.color]
        
        return StringUtils.shared.mutableAttributedString(message: message, links: [L10n.loginInfoLink], bodyAttr: bodyAttr, linkAttr: [linkAttr])
    }
}

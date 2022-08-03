//
//  SocialMedia.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.05.2022.
//

import Foundation
import UIKit

enum SocialMedia: Int, CaseIterable {
    case facebook, instagram, linkedin
    
    var icon: UIImage {
        switch self {
        case .facebook:
            return Asset.Images.facebook.image
        case .instagram:
            return Asset.Images.instagram.image
        case .linkedin:
            return Asset.Images.linkedin.image
        }
    }
    
    var name: String {
        switch self {
        case .facebook:
            return L10n.loginFacebook
        case .instagram:
            return L10n.loginInstagram
        case .linkedin:
            return L10n.loginLinkedin
        }
    }
}

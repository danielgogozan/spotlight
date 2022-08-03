//
//  TabBarButton.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

enum TabBarButton: Int, CaseIterable {
    case home
    case favorite
    case profile
    
    var title: String {
        switch self {
        case .home:
            return L10n.tabHome
        case .favorite:
            return L10n.tabFavorite
        case .profile:
            return L10n.tabProfile
        }
    }
    var image: UIImage {
        switch self {
        case .home:
            return Asset.Images.tabHome.image
        case .favorite:
            return Asset.Images.tabFavorite.image
        case .profile:
            return Asset.Images.tabProfile.image
        }
    }
    
    var selectedImage: UIImage {
        self.image.withColor(Asset.Colors.primary.color)
    }
}

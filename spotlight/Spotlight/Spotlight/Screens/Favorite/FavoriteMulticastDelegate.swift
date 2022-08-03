//
//  FavoriteMulticastDelegate.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 20.04.2022.
//

import Foundation

protocol AddableToFavorite {
    func toggleFavorite(isAddOperation: Bool)
    func filter(using article: Article) -> Bool
}

final class FavoriteMulticastDelegate: MulticastDelegate<AddableToFavorite> {
    
    static let shared = MulticastDelegate<AddableToFavorite>()
    
    private init() {
        super.init()
    }
    
}

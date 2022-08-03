//
//  FavoriteModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation

protocol FavoriteModuleFactory {
    func createFavoriteViewController() -> FavoriteViewController
}

extension DependencyContainer: FavoriteModuleFactory {
    func createFavoriteViewController() -> FavoriteViewController {
        let viewController = FavoriteViewController.instantiate(from: .Tab)
        viewController.viewModel = favoriteViewModel
        return viewController
    }
}

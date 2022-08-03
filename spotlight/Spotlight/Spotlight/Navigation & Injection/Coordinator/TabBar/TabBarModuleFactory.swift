//
//  TabBarModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

protocol TabBarModuleFactory {
    func createHomeCoordinator() -> HomeCoordinator
    func createFavoriteCoordinator() -> FavoriteCoordinator
    func createProfileCoordinator() -> ProfileCoordinator
}

extension DependencyContainer: TabBarModuleFactory {
    
    func createHomeCoordinator() -> HomeCoordinator {
        let navigationVc = CustomNavigationController()
        let coordinator = HomeCoordinator(navigationController: navigationVc, factory: self)
        return coordinator
    }
    
    func createFavoriteCoordinator() -> FavoriteCoordinator {
        let navigationVc = CustomNavigationController()
        let coordinator = FavoriteCoordinator(navigationController: navigationVc, factory: self)
        return coordinator
    }
    
    func createProfileCoordinator() -> ProfileCoordinator {
        let navigationVc = CustomNavigationController()
        let coordinator = ProfileCoordinator(navigationController: navigationVc, factory: self)
        return coordinator
    }
}

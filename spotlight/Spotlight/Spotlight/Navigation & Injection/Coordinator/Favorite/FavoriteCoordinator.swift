//
//  FavoriteCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

class FavoriteCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    private let navigationController: UINavigationController
    let factory: FavoriteModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: FavoriteModuleFactory) {
        self.factory = factory
        self.navigationController = navigationController
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
            showFavoriteViewController()
            wasLoaded = true
        }
    }
    
    func showFavoriteViewController() {
        let viewController = factory.createFavoriteViewController()
        navigationController.setViewControllers([viewController], animated: true)
    }
    
}

//
//  ProfileCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

class ProfileCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    private let navigationController: UINavigationController
    let factory: ProfileModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: ProfileModuleFactory) {
        self.factory = factory
        self.navigationController = navigationController
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
            let viewController = factory.createProfileViewController()
            navigationController.setViewControllers([viewController], animated: true)
            wasLoaded = true
        }
    }
    
}

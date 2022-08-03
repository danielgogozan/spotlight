//
//  TabBarCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {
    
    private let tabBarController: CustomTabBarController
    private let factory: TabBarModuleFactory
    
    init(tabBarController: CustomTabBarController, factory: TabBarModuleFactory) {
        self.tabBarController = tabBarController
        self.factory = factory
        
        super.init(rootViewController: tabBarController)
    }
    
    override func start() {
        coordinatorManager.addDependecy(coordinator: factory.createHomeCoordinator())
        coordinatorManager.addDependecy(coordinator: factory.createFavoriteCoordinator())
        coordinatorManager.addDependecy(coordinator: factory.createProfileCoordinator())
        
        tabBarController.didTabChange = { [weak self] idx in
            print("Tab idx: \(idx)")
            self?.coordinatorManager.childCoordinators[idx].start()
        }

        tabBarController.setViewControllers(coordinatorManager.childCoordinators.map { $0.rootViewController }, animated: false)
        coordinatorManager.childCoordinators[tabBarController.selectedIndex].start()
    }
}

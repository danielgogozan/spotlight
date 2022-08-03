//
//  AppModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation

protocol AppModuleFactory {
    func createTabBarCoordinator() -> TabBarCoordinator
    func createAuthCoordinator() -> AuthCoordinator
}

extension DependencyContainer: AppModuleFactory {
    func createTabBarCoordinator() -> TabBarCoordinator {
        let tabController = CustomTabBarController.instantiate(from: .Tab)
        let tabBarCoordinator = TabBarCoordinator(tabBarController: tabController, factory: self)
        return tabBarCoordinator
    }
    
    func createAuthCoordinator() -> AuthCoordinator {
        let navigationVc = CustomNavigationController()
        let authCoordinator = AuthCoordinator(navigationController: navigationVc, factory: self)
        return authCoordinator
    }
}

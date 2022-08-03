//
//  AppCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    private let factory: AppModuleFactory
    private let window: UIWindow
    private let coordinatorManager: CoordinatorManagerProtocol
    private let launcher: LaunchInstructor
    
    init(window: UIWindow, factory: AppModuleFactory, coordinatorManager: CoordinatorManagerProtocol = CoordinatorManager(), keychainManager: KeychainManagerProtocol) {
        self.window = window
        self.factory =  factory
        self.coordinatorManager = coordinatorManager
        self.launcher =  LaunchInstructor(keychainManager: keychainManager)
    }
    
    func start() {
        switch launcher.launchFlow {
        case .auth:
            startAuthFlow()
        case .main:
            startMainFlow()
        }
    }
    
}

// MARK: - Private API
private extension AppCoordinator {
    func startMainFlow() {
        let tabCoordinator = factory.createTabBarCoordinator()
        window.rootViewController = tabCoordinator.rootViewController
        coordinatorManager.addDependecy(coordinator: tabCoordinator)
        
        tabCoordinator.start()
    }

    func startAuthFlow() {
        let authCoordinator = factory.createAuthCoordinator()
        window.rootViewController = authCoordinator.rootViewController
        coordinatorManager.addDependecy(coordinator: authCoordinator)
        
        authCoordinator.startMainFlow = { [weak self] in
            self?.startMainFlow()
        }
        
        authCoordinator.start()
    }
}

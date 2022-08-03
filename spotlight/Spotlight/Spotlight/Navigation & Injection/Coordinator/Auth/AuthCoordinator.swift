//
//  AuthCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import Foundation
import UIKit

class AuthCoordinator: RootContainerCoordinator {
    
    private let navigationController: UINavigationController
    private var tabCoordinator: TabBarCoordinator?
    
    var rootViewController: UIViewController { navigationController }
    let factory: AuthModuleFactory
    var startMainFlow: (() -> Void)?
    
    init(navigationController: UINavigationController, factory: AuthModuleFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        showLoginScreen()
    }
    
}

private extension AuthCoordinator {
    func showLoginScreen() {
        let loginVc = factory.createLoginViewController()
        loginVc.login = { [weak self] in
            self?.startMainFlow?()
        }
        navigationController.setViewControllers([loginVc], animated: true)
    }
}

//
//  BaseCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

class BaseCoordinator: NSObject, RootContainerCoordinator {
    
    var rootViewController: UIViewController
    
    var coordinatorManager: CoordinatorManagerProtocol
    
    init(rootViewController: UIViewController, coordinatorManager: CoordinatorManagerProtocol = CoordinatorManager()) {
        self.rootViewController = rootViewController
        self.coordinatorManager = coordinatorManager
    }
    
    // This method must be implemented by every coordinator that extends BaseCoordinator
    func start() {}
}

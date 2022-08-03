//
//  CoordinatorManager.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import Foundation

protocol CoordinatorManagerProtocol {
    var childCoordinators: [RootContainerCoordinator] { get set }
    
    func addDependecy(coordinator: RootContainerCoordinator)
    
    func removeDependency(coordinator: RootContainerCoordinator)
}

class CoordinatorManager: CoordinatorManagerProtocol {
    var childCoordinators = [RootContainerCoordinator]()
    
    func addDependecy(coordinator: RootContainerCoordinator) {
        if childCoordinators.contains(where: { $0 === coordinator }) {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(coordinator: RootContainerCoordinator) {
        guard let idx = childCoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        childCoordinators.remove(at: idx)
    }
}

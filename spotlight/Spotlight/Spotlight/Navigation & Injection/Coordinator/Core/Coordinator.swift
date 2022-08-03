//
//  Coordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol RootContainerCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}

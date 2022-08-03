//
//  ProfileModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation

protocol ProfileModuleFactory {
    func createProfileViewController() -> ProfileViewController
}

extension DependencyContainer: ProfileModuleFactory {
    func createProfileViewController() -> ProfileViewController {
        let viewController = ProfileViewController.instantiate(from: .Tab)
        return viewController
    }
}

//
//  LoginModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 09.05.2022.
//

import Foundation
import UIKit

protocol AuthModuleFactory {
    func createTabBarCoordinator() -> TabBarCoordinator
    func createLoginViewController() -> LoginViewController
}

extension DependencyContainer: AuthModuleFactory {

    func createLoginViewController() -> LoginViewController {
        let loginVc = LoginViewController.instantiate(from: .Auth)
        loginVc.viewModel = loginViewModel
        return loginVc
    }
}

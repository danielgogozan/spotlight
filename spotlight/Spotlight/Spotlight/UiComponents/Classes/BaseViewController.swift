//
//  BaseViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 18.02.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private func toggleTabBar(hide: Bool) {
        guard let tabBar = tabBarController as? CustomTabBarController else { return }
        tabBar.toggle(hide: hide)
    }
    
    func hideTabBar() {
        toggleTabBar(hide: true)
    }
    
    func showTabBar() {
        toggleTabBar(hide: false)
    }
    
}

class BaseTableViewController: UITableViewController {
    
    private func toggleTabBar(hide: Bool) {
        guard let tabBar = tabBarController as? CustomTabBarController else { return }
        tabBar.toggle(hide: hide)
    }
    
    func hideTabBar() {
        toggleTabBar(hide: true)
    }
    
    func showTabBar() {
        toggleTabBar(hide: false)
    }
    
}

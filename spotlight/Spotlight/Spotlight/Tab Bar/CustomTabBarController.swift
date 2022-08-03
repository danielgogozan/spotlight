//
//  CustomTabBarViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let newsTabBar = NewsTabBarCode()
    var didTabChange: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        setupTabBar()
    }

    func setupTabBar() {
        newsTabBar.delegate = self
        view.addSubview(newsTabBar)
        newsTabBar.centerXInSuperview()
        newsTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    
    func toggle(hide: Bool) {
        newsTabBar.toggle(hide: hide)
    }
}

extension CustomTabBarController: CustomTabBarDelegate {
    func didSelect(index: Int) {
        didTabChange?(index)
        // Important, without setting the selected index, the transition won't work.
        selectedIndex = index
    }
}

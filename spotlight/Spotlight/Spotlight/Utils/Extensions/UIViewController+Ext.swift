//
//  UIViewController+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import UIKit

extension UIViewController {

    class var storyboardId: String {
        return "\(self)"
    }
    
    static func instantiate(from appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(vc: self)
    }
    
    func withTransparentNavBar() {
        navigationController?.navigationBar.tintColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
    
    func withCustomNavBar(titleTextAttributes: [NSAttributedString.Key: Any]) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = titleTextAttributes
        
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.standardAppearance = appearance
    }
}

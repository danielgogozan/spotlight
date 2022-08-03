//
//  AppStoryboards.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.02.2022.
//

import UIKit

enum AppStoryboard: String {
    // swiftlint:disable identifier_name
    case Main
    case Tab
    case Auth
    case Discover
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(vc: T.Type) -> T {
        let storyboardId = (vc as UIViewController.Type).storyboardId
        // swiftlint:disable force_cast
        return instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

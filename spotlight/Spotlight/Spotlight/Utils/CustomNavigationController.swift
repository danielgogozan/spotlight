//
//  CustomNavigationController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.03.2022.
//

import UIKit

// Helper class in order to obtain different status bar styles in different view controllers
class CustomNavigationController: UINavigationController {
   override var preferredStatusBarStyle: UIStatusBarStyle {
       // return the style that the top view controller on the navigation stack specifies or the default style
       return topViewController?.preferredStatusBarStyle ?? .default
   }
}

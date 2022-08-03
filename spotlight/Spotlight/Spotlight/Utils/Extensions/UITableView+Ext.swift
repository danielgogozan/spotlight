//
//  UITableView+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 25.02.2022.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let reuseIdentifier = reuseIdentifier(ofType: type)
        register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueCell<T: UITableViewCell>(ofType type: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIdentifier(ofType: type), for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with reuse identifier")
        }
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(ofType type: T.Type, for section: Int) -> T {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier(ofType: type)) as? T else {
            fatalError("Couldn't dequeue cell with reuse identifier")
        }
        return headerFooter
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(ofType type: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier(ofType: type))
    }
    
    func reuseIdentifier<T>(ofType type: T.Type) -> String {
        return String(describing: type)
    }
    
}

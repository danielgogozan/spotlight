//
//  UICollectionView+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit

// MARK: - Core
extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(ofType type: T.Type) {
        let reuseIdentifier = reuseIdentifier(ofType: type)
        register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(ofType type: T.Type, at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseIdentifier(ofType: type), for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with reuse identifier")
        }
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(ofType type: T.Type, kind: String, at indexPath: IndexPath) -> T {
        guard let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier(ofType: type), for: indexPath) as? T else {
            fatalError("Couldn't dequeue reusable view with identifier: \(String(describing: T.self))")
        }
        return header
    }
    
    func registerHeader<T: UICollectionReusableView>(ofType type: T.Type) {
        let reuseIdentifier = reuseIdentifier(ofType: type)
        register(UINib.init(nibName: reuseIdentifier, bundle: nil),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: reuseIdentifier)
    }
    
    func reuseIdentifier<T>(ofType type: T.Type) -> String {
        return String(describing: type)
    }
    
}

// MARK: - Cells
extension UICollectionView {
    
    var fullyVisibleCells: [UICollectionViewCell] {
        let cells =  self.visibleCells.filter { cell in
            let cellRect = self.convert(cell.frame, to: self.superview)
            return self.frame.contains(cellRect)
        }
        
        return cells
    }
    
}

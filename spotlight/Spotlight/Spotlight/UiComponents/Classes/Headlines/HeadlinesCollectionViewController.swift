//
//  HeadlinesCollectionViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 23.02.2022.
//

import UIKit

// The same Horizontal Paginated Collection used in Home Tab but wrapped this time into a View Controller. Currently unused
class HeadlinesCollectionViewController: HPaginatedCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerCell(ofType: HeadlinesCell.self)
        customizerDelegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }
}

// MARK: - Data Source
extension HeadlinesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cell(collectionView, for: indexPath)
        return cell
    }
    
    func cell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueCell(ofType: HeadlinesCell.self, at: indexPath)
            // configure
            return cell
        case 1:
            let cell = collectionView.dequeueCell(ofType: HeadlinesCell.self, at: indexPath)
            // configure
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

extension HeadlinesCollectionViewController: CellCostumizationDelegate {
    func defaultCustomization(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeadlinesCell else { return }
        cell.toDefault()
    }
    
    func customCustomization(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? HeadlinesCell else { return }
        cell.toCustom()
    }
}

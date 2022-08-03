//
//  HeadlinesTableViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 26.02.2022.
//

import Foundation
import UIKit
import Combine

protocol HeadlinesNavigationDelegate: AnyObject {
    func onArticleDetails(articleViewModel: ArticleViewModel)
}

class HeadlinesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var headlinesCollectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var indexOfCellBeforeDragging = 0
    private var indexOfCurrentCell = 0
    private var articleViewModels: [ArticleViewModel] = []
    
    var customizerDelegate: CellCostumizationDelegate?
    var navigationDelegate: HeadlinesNavigationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headlinesCollectionView.dataSource = self
        headlinesCollectionView.delegate = self
        headlinesCollectionView.registerCell(ofType: HeadlinesCell.self)
        headlinesCollectionView.showsHorizontalScrollIndicator = false
        
        customizerDelegate = self
    
        configureCollectionViewLayout()
        
        activityIndicator.color = Asset.Colors.primary.color
        activityIndicator.style = .medium
    }
    
    func setup(articleViewModels: [ArticleViewModel], isLoading: Bool) {
        self.articleViewModels = articleViewModels
        if isLoading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        headlinesCollectionView.reloadData()
    }
}

// MARK: - Private
private extension HeadlinesTableViewCell {
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        // swiftlint:disable force_cast
        return headlinesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func configureCollectionViewLayout() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionViewFlowLayout.itemSize = CGSize(width: headlinesCollectionView.frame.size.width - 80, height: headlinesCollectionView.frame.size.height - 20)
    }
    
    // Where scrollView should snap to
    private func indexOfMainCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = headlinesCollectionView.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(articleViewModels.count - 1, index))
        return safeIndex
    }
}

// MARK: - Data Source
extension HeadlinesTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articleViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cell(collectionView, for: indexPath)
        return cell
    }
    
    func cell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueCell(ofType: HeadlinesCell.self, at: indexPath)
            cell.setup(articleViewModel: articleViewModels[indexPath.item])
//            if indexPath.row == indexOfCurrentCell {
//                cell.toCustom()
//            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationDelegate?.onArticleDetails(articleViewModel: articleViewModels[indexPath.item])
    }
}

// MARK: - Cell Customizer
extension HeadlinesTableViewCell: CellCostumizationDelegate {
    func defaultCustomization(at indexPath: IndexPath) {
        guard let cell = headlinesCollectionView.cellForItem(at: indexPath) as? HeadlinesCell else { return }
        cell.toDefault()
    }
    
    func customCustomization(at indexPath: IndexPath) {
        guard let cell = headlinesCollectionView.cellForItem(at: indexPath) as? HeadlinesCell else { return }
        cell.toCustom()
    }
}

// MARK: - Horizontal Paginated Collection View
extension HeadlinesTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMainCell()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /// stops scrollView sliding
        targetContentOffset.pointee = scrollView.contentOffset
        
        /// this will get the current cell if there is a SWIPE GESTURE (fast) or the previous/next cell if there is SLIDING (slow)
        let indexOfMainCell = self.indexOfMainCell()
        
        let swipeVelocityThreshold: CGFloat = 0.3 /// how strong should the user swipe in order to change the current cell
        let count = 10
        let slideToNext = indexOfCellBeforeDragging + 1 < count && velocity.x > swipeVelocityThreshold
        let slideToPrev = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let mainIsPrevious = indexOfMainCell == indexOfCellBeforeDragging
        
        let didUseSwipeGestureToSkipCell = mainIsPrevious && (slideToNext || slideToPrev)
        
        if didUseSwipeGestureToSkipCell {
            /// activated on short press scroll aka SWIPE GESTURE
            indexOfCurrentCell = indexOfCellBeforeDragging + (slideToNext ? 1 : -1)
            let nextIndexPath = IndexPath(row: indexOfCurrentCell, section: 0)
            
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: velocity.x,
                options: .allowUserInteraction,
                animations: { [weak self] in
                    self?.headlinesCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                },
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.customizerDelegate?.customCustomization(at: nextIndexPath)
                    self.customizerDelegate?.defaultCustomization(at: IndexPath(row: self.indexOfCellBeforeDragging, section: 0))
                })
            headlinesCollectionView.collectionViewLayout.invalidateLayout()
        } else {
            /// activated on long press scroll aka SLIDING
            indexOfCurrentCell = indexOfMainCell
            let indexPath = IndexPath(row: indexOfMainCell, section: 0)
            headlinesCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            /// prevent adding customization when main cell hasn't changed
            if indexOfMainCell != indexOfCellBeforeDragging {
                customizerDelegate?.customCustomization(at: indexPath)
                customizerDelegate?.defaultCustomization(at: IndexPath(row: indexOfCellBeforeDragging, section: 0))
                headlinesCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == indexOfCurrentCell {
            return CGSize(width: collectionViewFlowLayout.itemSize.width, height: collectionViewFlowLayout.itemSize.height + 10)
        }
        return collectionViewFlowLayout.itemSize
    }
}

//
//  HeadlinesCollectionViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 23.02.2022.
//

import UIKit

protocol CellCostumizationDelegate: AnyObject {
    func defaultCustomization(at indexPath: IndexPath)
    func customCustomization(at indexPath: IndexPath)
}

/*
 An abstract Horizontal Paginated Collection View that can be extended and customized.
 Currently not used in the project, but its methods are the same as in HeadlinesTableViewCell.swift
 */
class HPaginatedCollectionViewController: UICollectionViewController {

    private var indexOfCellBeforeDragging = 0
    private var indexOfCurrentCell = 0
    
    var customizerDelegate: CellCostumizationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureCollectionViewLayout()
    }
    
    func sectionInset() -> CGFloat {
        return 10
    }
    
}

// MARK: - Scroll View
extension HPaginatedCollectionViewController {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMainCell()
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /// stops scrollView sliding
        targetContentOffset.pointee = scrollView.contentOffset
        
        /// this will get the current cell if there is a SWIPE GESTURE (fast) or the previous/next cell if there is SLIDING (slow)
        let indexOfMainCell = self.indexOfMainCell()
        
        let swipeVelocityThreshold: CGFloat = 0.3 // how strong should the user swipe in order to change the current cell
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
                    self?.collectionViewLayout.collectionView!.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                },
                completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.customizerDelegate?.customCustomization(at: nextIndexPath)
                    self.customizerDelegate?.defaultCustomization(at: IndexPath(row: self.indexOfCellBeforeDragging, section: 0))
                })
            self.collectionView.collectionViewLayout.invalidateLayout()
        } else {
            /// activated on long press scroll aka SLIDING
            indexOfCurrentCell = indexOfMainCell
            let indexPath = IndexPath(row: indexOfMainCell, section: 0)
            collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    
            /// prevent adding customization when main cell hasn't changed
            if indexOfMainCell != indexOfCellBeforeDragging {
                customizerDelegate?.customCustomization(at: indexPath)
                customizerDelegate?.defaultCustomization(at: IndexPath(row: indexOfCellBeforeDragging, section: 0))
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
}

// MARK: - Private
private extension HPaginatedCollectionViewController {
    
    private var collectionViewFlowLayout: UICollectionViewFlowLayout {
        // swiftlint:disable force_cast
        return collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    private func configureCollectionViewLayout() {
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset(), bottom: 0, right: sectionInset())
        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewLayout.collectionView!.frame.size.width - 50,
                                                   height: collectionViewLayout.collectionView!.frame.size.height - 20)
    }
    
    /// Where scrollView should snap to
    private func indexOfMainCell() -> Int {
        let itemWidth = collectionViewFlowLayout.itemSize.width
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(10 - 1, index))
        return safeIndex
    }
    
}

// MARK: - Collection View Delegate Flow Layout
extension HPaginatedCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == indexOfCurrentCell {
            return CGSize(width: collectionViewLayout.collectionView!.frame.size.width - 50, height: collectionViewLayout.collectionView!.frame.size.height)
        }
        return collectionViewFlowLayout.itemSize
    }
}

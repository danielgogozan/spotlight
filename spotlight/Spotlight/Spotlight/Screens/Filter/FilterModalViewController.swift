//
//  FilterModalViewController.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.03.2022.
//

import UIKit

class FilterModalViewController: UIViewController {
    
    @IBOutlet private weak var dimmedView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var resetStackView: UIStackView!
    @IBOutlet private weak var resetLabel: UILabel!
    @IBOutlet private weak var filterCollectionView: UICollectionView!
    @IBOutlet private weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    var searchViewModel: SearchResultViewModel!
    var filterViewModel: FilterViewModel!
    
    private let dimmedAlpha = 0.3
    private let defaultHeight: CGFloat = 350
    private let minHeight: CGFloat = 150
    private var maxHeight: CGFloat = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        
        // For animation, hide container view
        containerViewBottomConstraint.constant = -1 * containerViewHeightConstraint.constant
        
        setupDismissGesture()
        setupPanGesture()
        setupView()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateDimmedView()
        animateContainerView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maxHeight = view.safeAreaLayoutGuide.layoutFrame.height
        containerView.layer.cornerRadius = 15
        
        resetStackView.layer.cornerRadius = resetStackView.frame.height / 2
        resetStackView.layer.borderWidth = 1
        resetStackView.layer.borderColor = UIColor.black.cgColor
    }
    
}

// MARK: - Private
extension FilterModalViewController {
    
    func setupView() {
        filterLabel.text = L10n.filter
        filterLabel.textColor = Asset.Colors.black.color
        filterLabel.font = FontFamily.Nunito.bold.font(size: 22)
        
        resetLabel.font = FontFamily.Nunito.semiBold.font(size: 12)
        resetLabel.textColor = Asset.Colors.black.color
        resetLabel.text = L10n.resetBtn
        
        resetStackView.isUserInteractionEnabled = true
        resetStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resetFilter(sender:))))
    }
    
    func setupCollectionView() {
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.registerCell(ofType: TagViewCell.self)
        filterCollectionView.registerCell(ofType: ButtonCollectionCell.self)
        filterCollectionView.registerHeader(ofType: CollectionViewHeader.self)
    }
    
    func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissModal))
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    @objc
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = containerViewHeightConstraint.constant - translation.y
        
        switch gesture.state {
        case .changed:
            // update the height as long as the new height is not exceeding maxHeight
            if newHeight < maxHeight {
                containerViewHeightConstraint.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < minHeight {
                self.dismissModal()
            } else if newHeight < defaultHeight {
                animateContainerHeight(newHeight: defaultHeight)
            } else if newHeight < maxHeight && isDraggingDown {
                animateContainerHeight(newHeight: defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(newHeight: maxHeight)
            }
        default:
            break
        }
    }
    
    @objc
    func dismissModal() {
        animateDismiss()
    }
    
    @objc
    func resetFilter(sender: UITapGestureRecognizer) {
        filterViewModel.reset()
        filterCollectionView.reloadData()
    }
}

// MARK: - Collection Data Source
extension FilterModalViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterViewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterViewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = filterViewModel.section(of: indexPath.section) else { return UICollectionViewCell() }
        
        switch sectionType {
        case .sort, .language:
            let cell = collectionView.dequeueCell(ofType: TagViewCell.self, at: indexPath)
            let tagName = filterViewModel.itemName(for: sectionType, at: indexPath.item)
            cell.setup(tagName: tagName, isSelected: filterViewModel.isItemSelected(at: indexPath), isDeselectable: true, onTagSelected: nil)
            return cell
        case .button:
            let cell = collectionView.dequeueCell(ofType: ButtonCollectionCell.self, at: indexPath)
            cell.setup(title: L10n.saveBtn, buttonWidth: collectionView.bounds.width) { [weak self] in
                self?.searchViewModel.setSortAndLanguageCategory(
                    sortCategory: self?.filterViewModel.currentSortCategory,
                    languageCategory: self?.filterViewModel.currentLanguageCategory)
                self?.dismissModal()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard filterViewModel.section(of: indexPath.section) != .button else { return UICollectionReusableView() }
        let header = collectionView.dequeueSupplementaryView(ofType: CollectionViewHeader.self, kind: kind, at: indexPath)
        header.setup(title: filterViewModel.headerTitle(in: indexPath.section))
        return header
    }
    
}

extension FilterModalViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard filterViewModel.section(of: section) != .button else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterViewModel.toggleCategory(at: indexPath)
        
        // LOL: - section header is changing position after refresh
        // collectionView.reloadSections(IndexSet([indexPath.section]))
        
        collectionView.reloadData()
    }
    
}

// MARK: - Animation
extension FilterModalViewController {
    
    func animateContainerView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func animateContainerHeight(newHeight height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func animateDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.dimmedAlpha
        }
    }
    
    func animateDismiss() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint.constant = -1 * self.containerViewHeightConstraint.constant
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = dimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
}

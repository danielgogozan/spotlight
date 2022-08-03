//
//  TagsTableViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 26.02.2022.
//

import Foundation
import UIKit

protocol TagsDelegate: AnyObject {
    func onFilterSelected()
}

class TagsTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    private var categories: [NewsCategory] = NewsCategory.allCases
    private var selectedCategories: [NewsCategory] = []
    private var onTagSelected: ((NewsCategory, Bool) -> Void)?
    private var isFilterEnabled = false {
        didSet {
            if !isFilterEnabled && categories.count == NewsCategory.allCases.count {
                categories.removeFirst()
                tagsCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - Public properties
    var delegate: TagsDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFilterTagsCollection()
        tagsCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedCategories = []
    }
    
    func setupFilterTagsCollection() {
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.dataSource = self
        tagsCollectionView.registerCell(ofType: TagViewCell.self)
    }
    
    func setup(selectedCategories: [NewsCategory], onTagSelected: @escaping ((NewsCategory, Bool) -> Void), isFilterEnabled: Bool = false) {
        self.selectedCategories = selectedCategories
        self.onTagSelected = onTagSelected
        self.isFilterEnabled = isFilterEnabled
        self.tagsCollectionView.reloadData()
    }
}

extension TagsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueCell(ofType: TagViewCell.self, at: indexPath)
            let category = categories[indexPath.item]
            cell.setup(
                tagName: category.rawValue.firstUppercased,
                isSelected: selectedCategories.contains(category),
                isDeselectable: !isFilterEnabled) { [weak self] isTagSelected in
                    guard let self = self else { return }
                    self.onTagSelected?(category, isTagSelected)
                    if category == .filter {
                        self.delegate?.onFilterSelected()
                    }
                }
            if category == .filter {
                cell.image = Asset.Images.filter.image
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
}

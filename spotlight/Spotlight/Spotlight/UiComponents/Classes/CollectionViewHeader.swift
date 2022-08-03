//
//  CollectionViewHeader.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.03.2022.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
    
}

// MARK: - Private API
extension CollectionViewHeader {
    private func setupView() {
        titleLabel.textColor = Asset.Colors.black.color
        titleLabel.font = FontFamily.Nunito.semiBold.font(size: 16)
    }
}

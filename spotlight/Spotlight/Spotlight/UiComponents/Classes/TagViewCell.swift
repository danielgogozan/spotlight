//
//  TagViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 24.02.2022.
//

import Foundation
import UIKit

class TagViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var tagView: TagView!
    
    var onTagSelected: ((Bool) -> Void)?
    
    var image: UIImage? {
        didSet {
            tagView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // enabling autolayout for the cell
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.fillSuperview()
    }
 
    override func prepareForReuse() {
        super.prepareForReuse()
        tagView.reset()
    }
    
    func setup(tagName: String, isSelected: Bool, isDeselectable: Bool, onTagSelected: ((Bool) -> Void)?) {
        tagView.tagName = tagName
        tagView.isSelected = isSelected
        tagView.onTagSelected = onTagSelected
        tagView.isDeselectable = isDeselectable
    }
    
}

//
//  HistoryTableCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 05.03.2022.
//

import Foundation
import UIKit

class HistoryTableCell: UITableViewCell {
    
    @IBOutlet private weak var historyIcon: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImage: UIImageView!
 
    var onDelete: (() -> Void)?
    var searchKey: String? {
        self.titleLabel.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = FontFamily.Nunito.regular.font(size: 15)
        titleLabel.textColor = Asset.Colors.black.color
        historyIcon.image = Asset.Images.history.image.withColor(Asset.Colors.black.color)
        arrowImage.image = Asset.Images.close.image.withColor(Asset.Colors.black.color)
        arrowImage.isUserInteractionEnabled = true
        arrowImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onDeleteTapped(_:))))
    }
    
    func setup(title: String, onDelete: @escaping (() -> Void)) {
        self.titleLabel.text = title
        self.onDelete = onDelete
    }
    
    @objc
    func onDeleteTapped(_ gesture: UITapGestureRecognizer) {
        onDelete?()
    }
    
}

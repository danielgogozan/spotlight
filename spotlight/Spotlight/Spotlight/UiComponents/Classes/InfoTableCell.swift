//
//  InfoTableCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.03.2022.
//

import Foundation
import UIKit

class InfoTableCell: UITableViewCell {
    
    @IBOutlet private weak var infoView: InfoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setup(image: UIImage, description: String) {
        infoView.setup(image: image, description: description)
    }
    
}

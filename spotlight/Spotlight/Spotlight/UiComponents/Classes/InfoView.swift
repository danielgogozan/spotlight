//
//  InfoView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 17.03.2022.
//

import Foundation
import UIKit

class InfoView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    func setup(image: UIImage, description: String) {
        imageView.image = image
        infoLabel.text = description
    }
    
}

private extension InfoView {
    
    func loadFromNib() {
        super.loadNib(from: InfoView.self)
        
        infoLabel.font = FontFamily.Nunito.semiBold.font(size: 18)
        infoLabel.textColor = Asset.Colors.black.color
    }
    
}

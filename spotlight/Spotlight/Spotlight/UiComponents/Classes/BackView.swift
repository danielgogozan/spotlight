//
//  BackView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 11.03.2022.
//

import Foundation
import UIKit

class BackView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 10
    }
    
}

private extension BackView {
    
    func loadFromNib() {
        loadNib(from: BackView.self)
        
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        containerView.addBlurEffect()
    }
}

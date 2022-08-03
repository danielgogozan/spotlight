//
//  ButtonCollectionCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.03.2022.
//

import Foundation
import UIKit

class ButtonCollectionCell: UICollectionViewCell {
    
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var widthActionButtonConstraint: NSLayoutConstraint!
    
    private var onSave: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionButton.layer.masksToBounds = true
        actionButton.layer.cornerRadius = actionButton.frame.height / 2
       
        // LOL: - This kills everything
        // actionButton.setTitle("SAVE", for: .normal)
        
        // LOL: This removes letter "e"
        // actionButton.titleLabel?.font = FontFamily.Nunito.extraBold.font(size: 16)
    }
    
    func setup(title: String, buttonWidth: CGFloat, onSave: @escaping (() -> Void)) {
        actionButton.setTitle(title, for: .normal)
        widthActionButtonConstraint.constant = buttonWidth
        self.onSave = onSave
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        onSave?()
    }
    
}

// MARK: - Private API
extension ButtonCollectionCell {
    
    func setupView() {
        let gradient = CAGradientLayer()
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: actionButton.layer.frame.size.width, height: actionButton.layer.frame.size.width)
        gradient.colors = [Asset.Colors.primary.color.cgColor, UIColor.white.cgColor]
        
        // Note: - Mark actionButton as custom and style as default in storyboard otherwise a lot of LOL's are going to happen.. IDKWHY
        actionButton.layer.addSublayer(gradient)
        actionButton.titleLabel?.font = FontFamily.Nunito.extraBold.font(size: 16)
        actionButton.tintColor = .white
    }
    
}

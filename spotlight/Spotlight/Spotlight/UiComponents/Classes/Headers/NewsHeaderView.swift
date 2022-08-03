//
//  TopHeadlinesHeader.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit

class NewsHeaderView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var seeAllButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    
    var onAction: (() -> Void)?
    var displayLabelOnly: Bool = false {
        didSet {
            seeAllButton.isHidden = true
            imageView.isHidden = true
        }
    }
    
    var attributedText: NSAttributedString? {
        didSet {
            titleLabel.attributedText = attributedText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib()
    }
    
    func setup(title: String, buttonText: String?, image: UIImage?, onAction: (() -> Void)?) {
        titleLabel.text = title
        image == nil ? (imageView.isHidden = true) : (imageView.image = image)
        
        guard let buttonText = buttonText, let onAction = onAction else {
            seeAllButton.isHidden = true
            return
        }
        
        self.onAction = onAction
        seeAllButton.setTitle(buttonText, for: .normal)
        seeAllButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onButtonTapped(_:))))
    }
    
    @IBAction func onButtonTapped(_ sender: Any) {
        onAction?()
    }

}

// MARK: - Private API
private extension NewsHeaderView {
    
    private func loadFromNib() {
        loadNib(from: NewsHeaderView.self)
        
        titleLabel.text = L10n.latestNews
        titleLabel.font = FontFamily.NewYorkSmall.heavy.font(size: 22)
        
        seeAllButton.setTitle(L10n.seeAll, for: .normal)
        seeAllButton.titleLabel?.font = FontFamily.Nunito.regular.font(size: 12)
        seeAllButton.titleLabel?.textColor = Asset.Colors.secondary.color
    }
    
}

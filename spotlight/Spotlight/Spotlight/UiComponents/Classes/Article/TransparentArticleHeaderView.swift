//
//  ArticleTransparentView.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 10.03.2022.
//

import Foundation
import UIKit

class TransparentArticleHeaderView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    var onFrameSet: ((CGFloat) -> Void)?
    
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
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        onFrameSet?(containerView.frame.height)
    }
    
    func setup(date: String?, title: String?, author: String?) {
        dateLabel.text = date
        titleLabel.text = title
        authorLabel.text = author
    }
    
}

private extension TransparentArticleHeaderView {
    
    func loadFromNib() {
        loadNib(from: TransparentArticleHeaderView.self)
        containerView.backgroundColor = .clear
        containerView.addBlurEffect()
        
        dateLabel.font = FontFamily.Nunito.semiBold.font(size: 12)
        dateLabel.textColor = Asset.Colors.black.color
        
        titleLabel.font = FontFamily.NewYorkSmall.heavy.font(size: 16)
        titleLabel.textColor = Asset.Colors.black.color
        
        authorLabel.font = FontFamily.Nunito.extraBold.font(size: 10)
        authorLabel.textColor = Asset.Colors.black.color
    }
    
}

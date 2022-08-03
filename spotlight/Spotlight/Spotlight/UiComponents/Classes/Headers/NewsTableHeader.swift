//
//  NewsTableHeader.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 27.02.2022.
//

import Foundation
import UIKit

class NewsTableHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newsHeaderView: NewsHeaderView!
    
    var onAction: (() -> Void)?
    
    var attributedText: NSAttributedString? {
        didSet {
            newsHeaderView.attributedText = attributedText
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        loadNib(from: NewsTableHeader.self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib(from: NewsTableHeader.self)
    }
    
    func setup(title: String, buttonText: String?, image: UIImage?, onAction: (() -> Void)?) {
        self.onAction = onAction
        newsHeaderView.setup(title: title, buttonText: buttonText, image: image) { [weak self] in
            self?.onAction?()
        }
    }
    
}

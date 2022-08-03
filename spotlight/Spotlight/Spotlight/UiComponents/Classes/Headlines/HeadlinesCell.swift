//
//  TopHeadlinesCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import UIKit
import Combine

class HeadlinesCell: UICollectionViewCell {
    
    static let reuseIdentifier = String(describing: HeadlinesCell.self)
    
    @IBOutlet weak var topArticleView: TopArticleView!
    
    private var articleViewModel: ArticleViewModel?
    
    private var cancellables: [AnyCancellable] = []
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }
    
    func setup(articleViewModel: ArticleViewModel ) {
        self.articleViewModel = articleViewModel
        bindViewModel()
    }
    
    func toDefault() {
        topArticleView.toDefault()
    }
    
    func toCustom() {
        topArticleView.toCustom()
    }
    
    private func bindViewModel() {
        articleViewModel?.articleSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] article in
                guard let article = article else { return }
                self?.topArticleView.setup(topHeadline: article)
            }
            .store(in: &cancellables)
    }
}

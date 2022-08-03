//
//  ArticleViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 25.02.2022.
//

import UIKit
import Combine

class ArticleViewCell: UITableViewCell {
    
    @IBOutlet private weak var articleView: ArticleView!
    
    private var articleViewModel: ArticleViewModel?
    private var cancellables: [AnyCancellable] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }
    
    func setup(articleViewModel: ArticleViewModel) {
        self.articleViewModel = articleViewModel
        articleView.setup(article: articleViewModel.articleSubject.value,
                          publishedDate: articleViewModel.articleDate.value,
                          isAddedToFavorite: articleViewModel.isAddedToFavorite.value) { [weak self] in
            self?.articleViewModel?.toggleToFavorite()
        }
        bindViewModel()
    }
    
    func bindViewModel() {
        articleViewModel?.isAddedToFavorite
            .receive(on: RunLoop.main)
            .sink { [weak self] isAddedToFavorite in
                self?.articleView.isAddedToFavorite = isAddedToFavorite
            }
            .store(in: &cancellables)
    }
}

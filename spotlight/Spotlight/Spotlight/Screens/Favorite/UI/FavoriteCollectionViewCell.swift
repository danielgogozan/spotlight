//
//  FavoriteCollectionViewCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 06.04.2022.
//

import UIKit
import Combine

class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    @IBOutlet private weak var articleView: ArticleView!
    
    private var articleViewModel: ArticleViewModel?
    private var subscribers: [AnyCancellable] = []
    
    // MARK: - Public properties & function
    var onRemove: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleView.titleLabelNumberOfLines = 3
        articleView.hideAuthorLabel = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscribers = []
    }
    
    func setup(articleViewModel: ArticleViewModel, onRemove: @escaping (() -> Void)) {
        self.articleViewModel = articleViewModel
        articleView.setup(article: articleViewModel.articleSubject.value, publishedDate: articleViewModel.articleDate.value, isAddedToFavorite: true) { [weak self] in
            self?.articleViewModel?.toggleToFavorite()
        }
        self.onRemove = onRemove
        bindViewModel()
    }

}

// MARK: - Private API
private extension FavoriteCollectionViewCell {
    
    func bindViewModel() {
        articleViewModel?.isAddedToFavorite
            .receive(on: RunLoop.main)
            .sink { [weak self] isAddedToFavorite in
                guard let self = self else { return }
                self.articleView.isAddedToFavorite = isAddedToFavorite
                if !isAddedToFavorite {
                    self.onRemove?()
                }
            }
            .store(in: &subscribers)
    }
    
}

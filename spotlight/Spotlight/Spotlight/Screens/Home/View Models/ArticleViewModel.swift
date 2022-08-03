//
//  ArticleViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 27.02.2022.
//

import Foundation
import Combine
import UIKit

class ArticleViewModel: Equatable {
    
    // MARK: - Private properties
    private var cancellables: [AnyCancellable] = []
    private let article: Article
    private let dateFormatter: DateFormatter
    
    // MARK: - Public properties
    let noSections = 2
    let articleSubject = CurrentValueSubject<Article?, Never>(nil)
    let articleDate = CurrentValueSubject<String, Never>("")
    let isAddedToFavorite = CurrentValueSubject<Bool, Never>(false)
    var currentArticle: Article {
        article
    }
    
    // MARK: - Public API
    init(article: Article, dateFormatter: DateFormatter = DateUtils.defaultDateFormatter(), addedToFavorite: Bool) {
        self.article = article
        self.dateFormatter = dateFormatter
        self.articleSubject.send(article)
        setArticleDate()
        self.isAddedToFavorite.send(addedToFavorite)
    }
    
    private func setArticleDate() {
        guard let publishedAt = article.publishedAt,
              let date = dateFormatter.date(from: publishedAt) else { return }
        let prettyDate = DateUtils.prettyArticleDate(for: date)
        articleDate.send(prettyDate)
    }
    
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.currentArticle == rhs.currentArticle
    }
}

// MARK: - Add/Remove to/from favorites
extension ArticleViewModel {
    
    func toggleToFavorite() {
        FavoriteStorageManager.shared.update(with: article) { [weak self] success, addOperationPerformed in
            guard let self = self else { return }
            if success {
                print("\(addOperationPerformed ? "Added" : "Removed") article \(addOperationPerformed ? "to" : "from") favorites.")
                FavoriteMulticastDelegate.shared.invokeAll { addableToFavorite in
                    addableToFavorite.filter(using: self.article)
                } with: { addableToFavorite in
                    addableToFavorite.toggleFavorite(isAddOperation: addOperationPerformed)
                }
            } else {
                print("An error ocurred while trying to add article to favorite.")
            }
        }
    }
    
}

// MARK: - AddableToFavorite protocol
extension ArticleViewModel: AddableToFavorite {
    func toggleFavorite(isAddOperation: Bool) {
        self.isAddedToFavorite.send(isAddOperation)
    }
    
    func filter(using article: Article) -> Bool {
        return article.title == self.article.title
    }
}

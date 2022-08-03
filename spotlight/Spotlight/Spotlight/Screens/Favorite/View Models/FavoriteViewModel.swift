//
//  FavoriteViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 06.04.2022.
//

import UIKit
import Combine

class FavoriteViewModel {
    
    enum FavoriteSection: Int, CaseIterable {
        case search
        case articles
    }
    
    // MARK: - Public properties
    private(set) var cellHeightMultiplicator: CGFloat = 1.5
    private(set) var noColumns: CGFloat = 2
    private(set) var cellSpacing: CGFloat = 10.0
    let articleViewModels: CurrentValueSubject<[ArticleViewModel], Never> = CurrentValueSubject([])
    
    var cellWidth: CGFloat = 0.0
    var searchKey: String = "" {
        didSet {
            searchKey.isEmpty ? getAll() : filterArticles()
        }
    }
    
    // MARK: - Public API
    func articleViewModel(at index: Int) -> ArticleViewModel? {
        guard index >= 0 && index < articleViewModels.value.count else { return nil }
        return articleViewModels.value[index]
    }
    
    var numberOfSections: Int {
        return FavoriteSection.allCases.count
    }
    
    func section(for index: Int) -> FavoriteSection {
        return FavoriteSection.allCases[index]
    }
    
    func numberOfItems(in section: Int) -> Int {
        switch self.section(for: section) {
        case .search:
            return 1
        case .articles:
            return articleViewModels.value.count
        }
    }
    
}

// MARK: - API Calls
extension FavoriteViewModel {
    
    func getAll() {
        guard searchKey.isEmpty else { filterArticles(); return }
        let viewModels: [ArticleViewModel] = FavoriteStorageManager.shared.getAll().map { currentArticle -> ArticleViewModel in
            let viewModel = ArticleViewModel(article: currentArticle, addedToFavorite: true)
            FavoriteMulticastDelegate.shared.addDelegate(viewModel)
            return viewModel
        }
        articleViewModels.send(viewModels)
    }
    
    func filterArticles() {
        let viewModels: [ArticleViewModel] = FavoriteStorageManager.shared.filter(by: searchKey).map { currentArticle -> ArticleViewModel in
            let viewModel = ArticleViewModel(article: currentArticle, addedToFavorite: true)
            FavoriteMulticastDelegate.shared.addDelegate(viewModel)
            return viewModel
        }
        articleViewModels.send(viewModels)
    }
    
}

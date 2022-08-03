//
//  HomeModuleFactory.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation

protocol HomeModuleFactory {
    func createHomeViewController() -> HomeViewController
    func createSearchViewController() -> SearchViewController
    func createSearchResultViewController(query: String) -> SearchResultViewController
    func createArticleDetailsViewController(viewModel: ArticleViewModel) -> ArticleDetailsViewController
    func createLatesNewsViewController(latestNews: [ArticleViewModel]) -> LatestNewsViewController
    func createFilterModalViewController(searchViewModel: SearchResultViewModel) -> FilterModalViewController
    func resetFilterViewModel()
}

extension DependencyContainer: HomeModuleFactory {
    func createHomeViewController() -> HomeViewController {
        let viewController = HomeViewController.instantiate(from: .Tab)
        viewController.viewModel = homeViewModel
        return viewController
    }
    
    func createSearchViewController() -> SearchViewController {
        let viewController = SearchViewController.instantiate(from: .Discover)
        viewController.viewModel = searchViewModel
        return viewController
    }
    
    func createArticleDetailsViewController(viewModel: ArticleViewModel) -> ArticleDetailsViewController {
        let viewController = ArticleDetailsViewController.instantiate(from: .Discover)
        viewController.viewModel = viewModel
        return viewController
    }
    
    func createLatesNewsViewController(latestNews: [ArticleViewModel]) -> LatestNewsViewController {
        let viewController = LatestNewsViewController.instantiate(from: .Discover)
        latestNewsViewModel.initLatestNews(articleViewModels: latestNews)
        viewController.viewModel = latestNewsViewModel
        return viewController
    }
    
    func createSearchResultViewController(query: String) -> SearchResultViewController {
        let viewController = SearchResultViewController.instantiate(from: .Discover)
        let searchResultViewModel = SearchResultViewModel(newsApiService: newsApiService, query: query)
        viewController.viewModel = searchResultViewModel
        return viewController
    }
    
    func createFilterModalViewController(searchViewModel: SearchResultViewModel) -> FilterModalViewController {
        let viewController = FilterModalViewController.instantiate(from: .Discover)
        viewController.filterViewModel = filterViewModel
        viewController.searchViewModel = searchViewModel
        return viewController
    }
    
    func resetFilterViewModel() {
        filterViewModel.reset()
    }
}

//
//  HomeCoordinator.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation
import UIKit

class HomeCoordinator: RootContainerCoordinator {
    
    var rootViewController: UIViewController { navigationController }
    private let navigationController: UINavigationController
    let factory: HomeModuleFactory
    private var wasLoaded: Bool
    
    init(navigationController: UINavigationController, factory: HomeModuleFactory) {
        self.factory = factory
        self.navigationController = navigationController
        self.wasLoaded = false
    }
    
    func start() {
        if !wasLoaded {
           showHomeScreen()
        }
    }
    
}

// MARK: - Navigation

private extension HomeCoordinator {
    
    func showHomeScreen() {
        let viewController = factory.createHomeViewController()
        viewController.onSearch = { [weak self] in
            self?.showSearchScreen()
        }
        viewController.onArticleDetails = { [weak self] articleViewModel in
            self?.showArticleDetailsScreen(viewModel: articleViewModel)
        }
        viewController.onLatestNews = { [weak self] latestNews in
            self?.showLatestNewsScreen(latestNews: latestNews)
        }
        navigationController.setViewControllers([viewController], animated: true)
        wasLoaded = true
    }
    
    func showArticleDetailsScreen(viewModel: ArticleViewModel) {
        let viewController = factory.createArticleDetailsViewController(viewModel: viewModel)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showLatestNewsScreen(latestNews: [ArticleViewModel]) {
        let viewController = factory.createLatesNewsViewController(latestNews: latestNews)
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchScreen() {
        let viewController = factory.createSearchViewController()
        viewController.onBack = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onSearchResult = { [weak self, weak viewController] query in
            self?.showSearchResultScreen(searchParentDelegate: viewController, query: query)
        }
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showSearchResultScreen(searchParentDelegate: SearchParentDelegate?, query: String) {
        let viewController = factory.createSearchResultViewController(query: query)
        viewController.onBack = { [weak self] in
            self?.factory.resetFilterViewModel()
            self?.navigationController.popViewController(animated: true)
        }
        viewController.onArticleDetails = { [weak self] articleViewModel in
            self?.showArticleDetailsScreen(viewModel: articleViewModel)
        }
        viewController.onFilterModal = { [weak self, weak viewController] in
            guard let viewController = viewController else { return }
            self?.showFilterModal(searchViewModel: viewController.viewModel)
        }
        viewController.delegate = searchParentDelegate
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showFilterModal(searchViewModel: SearchResultViewModel) {
        let viewController = factory.createFilterModalViewController(searchViewModel: searchViewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(viewController, animated: false)
    }
    
}

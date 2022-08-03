//
//  HomeViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation
import Combine

enum HomeSection: Int, CaseIterable {
    case headlines
    case tags
    case news
    case scrollLoading
}

class HomeViewModel {
    
    // Private properties
    private let newsApiService: NewsServiceProtocol
    private var cancellables: [AnyCancellable] = []
    private var currentPage = 0
    
    // MARK: - Public properties
    let topHeadlines = CurrentValueSubject<[ArticleViewModel], Never>([])
    let news = CurrentValueSubject<[ArticleViewModel], Never>([])
    let topHeadlinesOnLoading = PassthroughSubject<Bool, Never>()
    let newsOnLoading = CurrentValueSubject<Bool, Never>(false)
    let stopInfiniteScroll = CurrentValueSubject<Bool, Never>(false)
    
    var tags: [NewsCategory: Bool] = [:]
    
    var numberOfSections: Int {
        return HomeSection.allCases.count
    }
    
    var selectedCategories: [NewsCategory] {
        tags.filter { $0.value == true }.map { $0.key }
    }
    
    var newsCount: Int {
        return news.value.count
    }
    
    // MARK: - Public API
    init(newsApiService: NewsServiceProtocol) {
        self.newsApiService = newsApiService
        
        tags = Dictionary(uniqueKeysWithValues: NewsCategory.allCases.map { $0.rawValue == NewsCategory.general.rawValue ? ($0, true) : ($0, false) })
        getTopHeadlines()
    }
    
    func isCategorySelected(category: NewsCategory) -> Bool {
        return tags[category] ?? false
    }
    
    func numberOfCategories() -> Int {
        return NewsCategory.allCases.count
    }
    
    func tagNameFor(index: Int) -> String {
        NewsCategory.allCases[index].rawValue.firstUppercased
    }
    
    func toggleCategory(_ category: NewsCategory, _ isSelected: Bool) {
        resetData()
        tags[category] = isSelected
    }
    
    func resetData() {
        currentPage = 0
        news.send([])
        stopInfiniteScroll.send(false)
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = HomeSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .headlines:
            return 1
        case .tags:
            return 1
        case .news:
            return news.value.count
        case .scrollLoading:
            return stopInfiniteScroll.value ? 0 : 1
        }
    }
}

// MARK: - API
extension HomeViewModel {
    
    func getTopHeadlines() {
        let headlinesFilter = HeadlinesFilter()
        headlinesFilter.country = Country.ro.rawValue
        
        newsApiService.getArticles(request: RequestType.news(headlinesFilter))
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.topHeadlinesOnLoading.send(true)
            }, receiveCompletion: { [weak self] _ in
                self?.topHeadlinesOnLoading.send(false)
            }, receiveCancel: { [weak self] in
                self?.topHeadlinesOnLoading.send(false)
            })
            .sink { _ in
            } receiveValue: { [weak self] news in
                guard let self = self else { return }
                let articleViewModels = news.articles.map { ArticleViewModel(article: $0, addedToFavorite: false)}
                self.topHeadlines.send(articleViewModels)
            }
            .store(in: &cancellables)
    }
    
    func getMoreNews() {
        if newsOnLoading.value || stopInfiniteScroll.value {
            // there is already an API request in progress or no more data available
            return
        }
        currentPage += 1
        getNews()
    }
    
    func getNews() {
        let headlinesFilter = HeadlinesFilter(categories: selectedCategories, pageNumber: currentPage, country: .gb)
        
        newsApiService.getArticles(request: RequestType.news(headlinesFilter))
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.newsOnLoading.send(true)
            }, receiveCompletion: { [weak self] _ in
                self?.newsOnLoading.send(false)
            }, receiveCancel: { [weak self] in
                self?.newsOnLoading.send(false)
            })
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.stopInfiniteScroll.send(true)
                default:
                    break
                }
            } receiveValue: { [weak self] news in
                guard let self = self, news.totalResults > 0 else { return }
                let articles = news.articles
                let articleViewModels = articles.map { currentArticle -> ArticleViewModel in
                    let articleViewModel = ArticleViewModel(article: currentArticle, addedToFavorite: self.checkIfAddedToFavorite(article: currentArticle))
                    FavoriteMulticastDelegate.shared.addDelegate(articleViewModel)
                    return articleViewModel
                }
                
                self.news.appendAndSend(articleViewModels)
            }
            .store(in: &cancellables)
    }
    
    private func checkIfAddedToFavorite(article: Article) -> Bool {
        return FavoriteStorageManager.shared.isAlreadyPersisted(article)
    }
}

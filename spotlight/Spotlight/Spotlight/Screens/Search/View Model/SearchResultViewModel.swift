//
//  SearchResultViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.03.2022.
//

import Foundation
import Combine

class SearchResultViewModel {
    
    // MARK: - Private & readonly properties
    private let newsApiService: NewsServiceProtocol
    private var cancellables = [AnyCancellable]()
    private var currentPage = 0
    private(set) var query = ""
    private(set) var resultCount = 0
    private(set) var selectedCategory = CurrentValueSubject<NewsCategory, Never>(.filter)
    private(set) var selectedSortCategory: Sorter?
    private(set) var selectedLanguageCategory: Language?
    
    // MARK: - Public properties
    var articlesSubject = CurrentValueSubject<[ArticleViewModel], Never>([])
    var state = CurrentValueSubject<SearchState, Never>(.idle)
    
    // MARK: - Public API
    init(newsApiService: NewsServiceProtocol, query: String = "") {
        self.newsApiService = newsApiService
        self.query = query
    }
    
    func setCategory(_ category: NewsCategory) {
        guard selectedCategory.value != category else { return }
        selectedCategory.send(category)
        resetData()
        state.send(.loading)
        search()
    }
    
    func setSortAndLanguageCategory(sortCategory: Sorter?, languageCategory: Language?) {
        selectedSortCategory = sortCategory
        selectedLanguageCategory = languageCategory
        resetData()
        search()
    }
    
    func getResults(newQuery: String? = nil) {
        if let newQuery = newQuery, !newQuery.isEmpty, newQuery != query {
            query = newQuery
            resetData()
            search()
            return
        }
        
        if state.value == .loading || state.value == .noMoreDate { return }
        currentPage += 1
        search()
    }
    
}

// MARK: - Private API
private extension SearchResultViewModel {
    
    func search() {
        let newsFilter = selectedCategory.value == .filter ? NewsFilter(query: query,
                                                                        pageNumber: currentPage,
                                                                        sortBy: selectedSortCategory,
                                                                        language: selectedLanguageCategory) :
        HeadlinesFilter(categories: [selectedCategory.value], pageNumber: currentPage, query: query, country: nil)
        let request = RequestType.news(newsFilter)
        
        newsApiService.getArticles(request: request)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.state.send(.loading)
                },
                receiveCancel: { [weak self] in
                    self?.state.send(.idle)
                })
            .sink { [weak self] completion in
                switch completion {
                case .failure:
                    self?.state.send(.error)
                    self?.state.send(.noMoreDate)
                default:
                    break
                }
            } receiveValue: { [weak self] news in
                guard let self = self else { return }
                let articleViewModels = news.articles
                    .map { article -> ArticleViewModel in
                        let articleViewModel = ArticleViewModel(article: article, addedToFavorite: self.checkIfAddedToFavorite(article: article))
                        FavoriteMulticastDelegate.shared.addDelegate(articleViewModel)
                        return articleViewModel
                    }
                
                self.resultCount = news.totalResults
                self.articlesSubject.appendAndSend(articleViewModels)
                if articleViewModels.count == 0 || articleViewModels.count < newsFilter.pageSize {
                    self.state.send(.noMoreDate)
                } else {
                    self.state.send(.data(self.articlesSubject.value))
                }
            }
            .store(in: &cancellables)
    }
    
    func resetData() {
        currentPage = 1
        articlesSubject.send([])
    }
    
    private func checkIfAddedToFavorite(article: Article) -> Bool {
        return FavoriteStorageManager.shared.isAlreadyPersisted(article)
    }
}

// MARK: - Table View Logic
extension SearchResultViewModel {
    
    var numberOfSections: Int {
        SearchResultSection.allCases.count
    }
    
    var showArticlesResultHeader: Bool {
        return !(articlesSubject.value.count == 0)
    }
    
    func section(of index: Int) -> SearchResultSection? {
        SearchResultSection(rawValue: index)
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = SearchResultSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .tags:
            return 1
        case .articles:
            return articlesSubject.value.count
        case .loading:
            return state.value == .noMoreDate ? 0 : 1
        case .info:
            return state.value == .noMoreDate && articlesSubject.value.count == 0 ? 1 : 0
        }
    }
    
    func articleViewModel(at index: Int) -> ArticleViewModel {
        return articlesSubject.value[index]
    }
    
    func resultsHeaderMessage() -> NSMutableAttributedString {
        let message = L10n.searchSummary(resultCount.description, query)
        let bodyAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.regular.font(size: 14),
                                                             .foregroundColor: Asset.Colors.black.color]

        let resultsAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.regular.font(size: 14),
                                                                .foregroundColor: Asset.Colors.primary.color]
        
        let queryAttr: [NSAttributedString.Key: Any] = [.font: FontFamily.Nunito.semiBoldItalic.font(size: 14),
                                                             .foregroundColor: Asset.Colors.black.color]
        let linkAttr = [resultsAttr, queryAttr]
        
        return StringUtils.shared.mutableAttributedString(message: message, links: [resultCount.description, query], bodyAttr: bodyAttr, linkAttr: linkAttr)
    }
    
}

// MARK: - Enums
extension SearchResultViewModel {
    
    enum SearchState: Equatable {
        case idle
        case loading
        case data([ArticleViewModel])
        case error
        case noMoreDate
        
        static func == (lhs: SearchResultViewModel.SearchState, rhs: SearchResultViewModel.SearchState) -> Bool {
            switch(lhs, rhs) {
            case (.idle, .idle), (.loading, .loading), (.error, .error), (.noMoreDate, .noMoreDate):
                return true
            case (.data(let d1), .data(let d2)):
                return d1 == d2
            default:
                return false
            }
        }
    }
    
    enum SearchResultSection: Int, CaseIterable {
        case tags
        case articles
        case loading
        case info
    }
    
}

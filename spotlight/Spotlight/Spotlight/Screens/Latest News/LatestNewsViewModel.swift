//
//  LatestNewsViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 14.03.2022.
//

import Foundation
import Combine
import SystemConfiguration

class LatestNewsViewModel {
    
    enum LatestNewsSection: Int, CaseIterable {
        case news
        case loading
    }
    
    private let newsApiService: NewsServiceProtocol
    private var cancellables: [AnyCancellable] = []
    private var currentPage = 0
    
    let latestNews = CurrentValueSubject<[ArticleViewModel], Never>([])
    let newsOnLoading = CurrentValueSubject<Bool, Never>(false)
    let stopInfiniteScroll = CurrentValueSubject<Bool, Never>(false)
    let numberOfSections = LatestNewsSection.allCases.count
    var expandedNewsIdxs: [Int] = []
    
    init(newsApiService: NewsServiceProtocol, articles: [ArticleViewModel] = []) {
        self.newsApiService = newsApiService
        
        if articles.count > 0 {
            currentPage = 1
            latestNews.send(articles)
        }
    }
    
    func initLatestNews(articleViewModels: [ArticleViewModel]) {
        if articleViewModels.isEmpty {
            return
        }
        currentPage = 1
        latestNews.send(articleViewModels)
    }
    
    func getMoreNews() {
        if newsOnLoading.value || stopInfiniteScroll.value {
            return
        }
        currentPage += 1
        getLatestNews()
    }
    
    func rowsInSection(_ section: Int) -> Int {
        guard let sectionType = LatestNewsSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .news:
            return latestNews.value.count
        case .loading:
            return stopInfiniteScroll.value ? 0 : 1
        }
    }
    
    func sectionType(from section: Int) -> LatestNewsSection? {
        return LatestNewsSection(rawValue: section)
    }
    
    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return latestNews.value[indexPath.row]
    }
    
    func toggleArticle(at index: Int) {
        if let removedIndex = expandedNewsIdxs.firstIndex(where: { $0 == index }) {
            expandedNewsIdxs.remove(at: removedIndex)
            return
        }
        expandedNewsIdxs.append(index)
    }
    
    func showFullDescription(for index: Int) -> Bool {
        return expandedNewsIdxs.contains(where: { $0 == index })
    }
    
    func onDeinit() {
        expandedNewsIdxs = []
    }
}

// MARK: - Private API
private extension LatestNewsViewModel {
    
    func getLatestNews() {
        let filter = HeadlinesFilter(categories: [], pageNumber: currentPage, country: .gb)
        let request = RequestType.news(filter)
        
        newsApiService.getArticles(request: request)
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
                // TODO: - added to favorites check
                let articleViewModels = articles.map { ArticleViewModel(article: $0, addedToFavorite: false)}
            
                var currentNews = self.latestNews.value
                currentNews.append(contentsOf: articleViewModels)
                self.latestNews.send(currentNews)
            }
            .store(in: &cancellables)
    }

}

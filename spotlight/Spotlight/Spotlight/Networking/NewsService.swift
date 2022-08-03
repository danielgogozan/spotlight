//
//  APINewsService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.02.2022.
//

import Foundation
import Combine
import UIKit

protocol NewsServiceProtocol: AnyObject {
    init(apiService: APIServiceProtocol)
    
    func getArticles(request: Request) -> AnyPublisher<News, APIError>
    func getImage(urlString: String?) -> AnyPublisher<UIImage, Never>
}

class NewsService: NewsServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getArticles(request: Request) -> AnyPublisher<News, APIError> {
        return apiService.request(request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .print()
            .map { news in
                return news
            }
            .eraseToAnyPublisher()
    }
    
    func getImage(urlString: String?) -> AnyPublisher<UIImage, Never> {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return AnyPublisher(Just(Asset.Images.breakingNews.image)) }
        return apiService.imageRequest(url: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
}

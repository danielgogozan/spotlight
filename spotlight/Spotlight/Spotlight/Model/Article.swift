//
//  News.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import UIKit

protocol TopHeadline {
    var author: String? { get }
    var title: String { get }
    var description: String? { get }
    var imageUrl: String? { get }
}

struct Source: Codable {
    let id: String?
    let name: String
}

struct Article: Codable, TopHeadline, Equatable {
    
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var url: String?
    var imageUrl: String?
    var publishedAt: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, publishedAt, content
        case imageUrl = "urlToImage"
    }
    
    var urlToImage: URL? {
        guard let url = imageUrl else { return URL(string: "")}
        return URL(string: url)
    }
    
    // appareantly source is not a unique key for every article, hence we will consider the title of the article as being part of source.name
    var mockedSourceName: String {
        return source.name+"#"+title
    }
    
    init() {
        source = Source(id: nil, name: "")
        self.title = ""
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.source.id == rhs.source.id &&
        lhs.author == rhs.author &&
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.url == rhs.url &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.content == rhs.content
    }
}

struct News: Codable {
    let totalResults: Int
    let articles: [Article]
}

struct NewsErrorResponse: Codable {
    let code: String
    let message: String
}

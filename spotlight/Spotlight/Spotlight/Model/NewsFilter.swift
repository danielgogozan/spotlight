//
//  NewsParams.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import UIKit

enum NewsType {
    case topHeadlines
    case news
}

class BaseNewsFilter {
    var type: NewsType = .news
    var query: String?
    var pageSize: Int = 10
    var pageNumber: Int = 1
    
    var params: [String: Any] {
        var paramsDict: [String: String] = [:]
        if let query = query {
            paramsDict["q"] = query
        }
        paramsDict["pageSize"] = pageSize.description
        paramsDict["page"] = pageNumber.description
        return paramsDict
    }
}

class NewsFilter: BaseNewsFilter {
    var fromDate: Date?
    var toDate: Date?
    var language: Language?
    var sortBy: Sorter?
    
    override init() {
        super.init()
    }
    
    init(query: String?, pageNumber: Int, sortBy: Sorter? = nil, language: Language? = nil) {
        super.init()
        self.query = query
        self.pageNumber = pageNumber
        self.sortBy = sortBy
        self.language = language
    }
    
    override var params: [String: Any] {
        var paramsDict = super.params
        if let fromDate = fromDate {
            paramsDict["from"] = fromDate.description
        }
        if let toDate = toDate {
            paramsDict["to"] = toDate.description
        }
        if let language = language {
            paramsDict["language"] = language.rawValue
        }
        if let sortBy = sortBy {
            paramsDict["sortBy"] = sortBy.rawValue
        }
        return paramsDict
    }
}

class HeadlinesFilter: BaseNewsFilter {
    var country: String?
    var categories: [NewsCategory]?
    /// cannot be mixed with country or category
    var sources: String?
    
    override init() {
        super.init()
        self.type = .topHeadlines
    }
    
    init(categories: [NewsCategory], pageNumber: Int, query: String? = nil, country: Country? ) {
        super.init()
        self.type = .topHeadlines
        self.categories = categories
        self.pageNumber = pageNumber
        self.query = query
        
        /// just to fetch more diverse news
        self.country = country?.rawValue
    }
    
    override var params: [String: Any] {
        var paramsDict = super.params
        if let sources = sources {
            paramsDict["sources"] = sources
            return paramsDict
        }
       
        if let country = country {
            paramsDict["country"] = country
        }
        
        if let sources = sources {
            paramsDict["sources"] = sources
        }
        
        if let categories = categories, categories.count > 0 {
            paramsDict["category"] = categories.map { $0.rawValue }
        }
        
        return paramsDict
    }
}

enum NewsCategory: String, CaseIterable {
    case filter
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
}

enum Language: String, CaseIterable {
    case en
    case de
    case it
    case no
    case fr
}

enum Sorter: String, CaseIterable {
    case relevancy
    case popularity
    /// newest articles come first
    case publishedAt
}

enum Country: String {
    case ro
    case gb
}

//
//  RequestBuilder.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation

enum RequestType {
    case news(BaseNewsFilter)
    case login(Credentials)
}

extension RequestType: Request {
    
    var httpMethod: HTTPMethod {
        switch self {
        case .news:
            return .get
        case .login:
            return .post
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .news, .login:
            return defaultHeaders()
        }
    }
    
    var baseUrl: String {
        switch self {
        case .news:
            return Constants.newsUrl
        case .login:
            return Constants.authUrl
        }
    }
    
    var path: String {
        switch self {
        case .news(let filter):
            switch filter.type {
            case .news:
                return "everything"
            case .topHeadlines:
                return "top-headlines"
            }
        case .login:
            return "login"
        }
    }
    
    var queryParams: [String: Any] {
        switch self {
        case .news(let newsFilter):
            var params = newsFilter.params
            params += defaultParams()
            return params
        case .login:
            return [:]
        }
    }
    
    var body: Encodable? {
        switch self {
        case .news:
            return nil
        case .login(let credentials):
            return credentials
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseUrl),
              var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Could not create URL")
        }
        
        components.queryItems = []
        queryParams.forEach { key, value in
            if let arr = value as? [String] {
                arr.forEach { components.queryItems?.append(URLQueryItem(name: key, value: $0)) }
            } else if let value = value as? String {
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
        }
        
        guard let url = components.url else {
            fatalError("Unable to obtain url from components")
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        if body != nil {
            // This switch is mandatory as encode(...) expects an object with conrete type
            switch self {
            case .login(let credentials):
                request.httpBody = try? JSONEncoder().encode(credentials)
            default:
                break
            }
        }
        headers.forEach { request.addValue($1, forHTTPHeaderField: $0) }
        
        return request
    }
}

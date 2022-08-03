//
//  Request.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import Alamofire

enum HTTPMethod: String {
    case get
    case post
}

protocol Request: URLRequestConvertible {
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var baseUrl: String { get }
    var path: String { get }
    var queryParams: [String: Any] { get }
    var body: Encodable? { get }
}

extension Request {
    
    func defaultHeaders() -> [String: String] {
        ["Content-Type": "application/json"]
    }
    
    func defaultParams() -> [String: String] {
        ["apiKey": Constants.apiKey]
    }
    
}

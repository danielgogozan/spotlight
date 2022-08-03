//
//  APIService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import Alamofire
import Combine

protocol APIServiceProtocol {
    func request<T: Codable>(_ request: Request) -> AnyPublisher<T, APIError>
    func imageRequest(url: URL) -> AnyPublisher<UIImage, Never>
}
enum APIError: Error {
    case decodingError
    case apiError(code: Int?, message: String)
    case noData
    case unknown
}

class APIService: APIServiceProtocol {
    
    func request<T: Codable>(_ request: Request) -> AnyPublisher<T, APIError> {
        return AF.request(request).publishDecodable(type: T.self, queue: DispatchQueue.global(qos: .background))
            .print()
            .tryCompactMap { response in
                
                if let error = response.error {
                    throw APIError.apiError(code: error.responseCode, message: error.localizedDescription)
                }
                
                guard let data = response.data else {
                    throw APIError.noData
                }
                
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError
                }
            }
            .mapError { error -> APIError in
                guard let error = error as? APIError else { return APIError.unknown}
                return error
            }
            .eraseToAnyPublisher()
    }
    
    func imageRequest(url: URL) -> AnyPublisher<UIImage, Never> {
        do {
            let urlRequest = try URLRequest(url: url, method: .get, headers: nil)
            return AF.request(urlRequest).publishData()
                .compactMap { response -> UIImage in
                    if let data = response.data,
                       let img = UIImage(data: data) {
                        return img
                    } else {
                        return Asset.Images.breakingNews.image
                    }
                }
                .eraseToAnyPublisher()
            
        } catch {
            return AnyPublisher(Just(Asset.Images.breakingNews.image))
        }
    }
}

//
//  AuthService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.05.2022.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    init(apiService: APIServiceProtocol)
    func login(with credentials: Credentials) -> AnyPublisher<Token, APIError>
    
}

class AuthService: AuthServiceProtocol {
    
    let apiService: APIServiceProtocol
    
    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func login(with credentials: Credentials) -> AnyPublisher<Token, APIError> {
        let request = RequestType.login(credentials)
        return apiService.request(request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
    
}

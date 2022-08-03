//
//  LoginViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.05.2022.
//

import Foundation
import Combine

class LoginViewModel {
    
    // MARK: - Private properties
    private let apiService: AuthServiceProtocol
    private let keychainManager: KeychainManagerProtocol
    private var credentials = Credentials(email: "", password: "")
    private var subscriptions: [AnyCancellable] = []
    
    // MARK: - Public properties
    @Published var email: String?
    @Published var password: String?
    let emailPublisher = PassthroughSubject<String?, Never>()
    let passwordPublisher = PassthroughSubject<String?, Never>()
    let loginResultPublisher = PassthroughSubject<String?, Never>()
    
    var credentialsValidator: AnyPublisher<(String, String)?, Never> {
            return Publishers.CombineLatest(emailValidator, passwordValidator)
                .map { [weak self] email, pass in
                    
                    guard let email = email, let pass = pass else {
                        return nil
                    }
                    
                    self?.credentials = Credentials(email: email, password: pass)
                    
                    return (email, pass)
            }
            .eraseToAnyPublisher()
        }
    
    init(apiService: AuthServiceProtocol, keychainManager: KeychainManagerProtocol) {
        self.apiService = apiService
        self.keychainManager = keychainManager
    }
    
    // MARK: - Public API
    func login() -> AnyPublisher<Token, APIError> {
        // we're mocking login credentials because the API accepts only certain emails&password
        return apiService.login(with: Constants.goodCredentials)
            .print()
            .map { [weak self] token in
                self?.keychainManager.save(token, service: Constants.kTokenService, account: Constants.kTokenAccount)
                return token
            }
            .eraseToAnyPublisher()
    }
    
}

// MARK: - Private API
private extension LoginViewModel {
    
    // Publisher to publisher
    var emailValidator: AnyPublisher<String?, Never> {
        return $email
            .map { [weak self] text -> String? in
                guard let self = self else { return nil }
                guard let text = text else { self.emailPublisher.send(nil); return nil }
    
                guard !text.isEmpty else {
                    self.emailPublisher.send("Please, enter your email")
                    return nil
                }
                
                guard self.isValidEmail(text) else {
                    self.emailPublisher.send("Invalid email address")
                    return nil
                }
                
                self.emailPublisher.send("")
                
                return text
            }
            .eraseToAnyPublisher()
    }
    
    var passwordValidator: AnyPublisher<String?, Never> {
        return $password
            .map { [weak self] text in
                guard let self = self else { return nil }
                guard let text = text else { self.passwordPublisher.send(nil); return nil }

                guard !text.isEmpty else {
                    self.passwordPublisher.send("Please, enter your password")
                    return nil
                }
                
                self.passwordPublisher.send("")
                
                return text
            }
            .eraseToAnyPublisher()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
}

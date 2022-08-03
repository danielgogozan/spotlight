//
//  DependencyContainer.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.02.2022.
//

import Foundation

class DependencyContainer {
    
    // MARK: - API
    lazy var apiService = APIService()
    lazy var newsApiService = NewsService(apiService: apiService)
    lazy var authService = AuthService(apiService: apiService)
    
    // MARK: - View Models
    lazy var homeViewModel = HomeViewModel(newsApiService: newsApiService)
    lazy var searchViewModel = SearchViewModel(newsApiService: newsApiService, searchManager: searchManager)
    lazy var latestNewsViewModel = LatestNewsViewModel(newsApiService: newsApiService)
    lazy var filterViewModel = FilterViewModel()
    lazy var favoriteViewModel = FavoriteViewModel()
    lazy var loginViewModel = LoginViewModel(apiService: authService, keychainManager: keychainManager)
    
    // MARK: - Storage Managers
    let searchManager = SearchStorageManager()
    
    // MARK: - Keychain Manager
    lazy var keychain = Keychain()
    lazy var keychainManager = KeychainManager(keychain: keychain)
}

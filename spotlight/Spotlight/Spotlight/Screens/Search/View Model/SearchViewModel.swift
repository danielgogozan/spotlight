//
//  SearchViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 05.03.2022.
//

import Foundation
import Combine

class SearchViewModel {
    
    private let newsApiService: NewsServiceProtocol
    private let searchManager: SearchStorageManagerProtocol
    
    let history = CurrentValueSubject<[Search], Never>([])
    
    init(newsApiService: NewsServiceProtocol, searchManager: SearchStorageManagerProtocol) {
        self.newsApiService = newsApiService
        self.searchManager = searchManager
    }
    
    var numberOfRows: Int {
        history.value.count
    }
    
    func searchTitle(at index: Int) -> String {
        history.value[index].key ?? ""
    }
    
    func getHistory() {
        history.send(searchManager.getAll())
    }
    
    func save(searchKey: String) {
        searchManager.save(searchKey: searchKey) { [weak self] search, isUpdate in
            guard let self = self else { return }
            var updatedHistory = self.history.value
            
            if isUpdate,
               let idx = updatedHistory.firstIndex(where: { $0.key == searchKey }) {
                updatedHistory.remove(at: idx)
            }
            
            updatedHistory.insert(search, at: 0)
            self.history.send(updatedHistory)
        }
    }
    
    func remove(searchKey: String) {
        // LOL: - if line 52 is included in the if statement, the if body will get skipped..
        let idx = history.value.firstIndex(where: { $0.key == searchKey })
        
        if searchManager.remove(searchKey: searchKey), let idx = idx {
            var updatedHistory = history.value
            updatedHistory.remove(at: idx)
            history.send(updatedHistory)
        }
    }
}

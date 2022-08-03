//
//  SearchManager.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 30.03.2022.
//

import Foundation
import UIKit

protocol SearchStorageManagerProtocol: StorageManagerProtocol {
    func getAll() -> [Search]
    func save(searchKey: String, completion: @escaping ((Search, Bool) -> Void))
    func find(searchKey: String) -> Search?
    func contains(searchKey: String) -> Bool
    func remove(searchKey: String) -> Bool
    func update(searchKey: String, completion: @escaping ((Search) -> Void))
}

class SearchStorageManager: SearchStorageManagerProtocol {
    
    var storageManager: StorageManager
    
    let fetchLimit = 10

    init() {
        storageManager = StorageManager.shared
    }
    
    func getAll() -> [Search] {
        let request = Search.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Search.date), ascending: false)
        
        request.fetchLimit = fetchLimit
        request.sortDescriptors = [sort]
        
        return storageManager.get(request: request)
    }
    
    func save(searchKey: String, completion: @escaping ((Search, Bool) -> Void)) {
        guard !contains(searchKey: searchKey) else {
            update(searchKey: searchKey) { search in
                completion(search, true)
            }
            return
        }
        
        let search = Search(context: storageManager.context)
        search.key = searchKey
        search.date = Date.now
        
        do {
            try storageManager.save()
            completion(search, false)
        } catch {
            print("Error while saving \(searchKey): \(error)")
        }
    }
    
    func find(searchKey: String) -> Search? {
        let request = Search.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", argumentArray: [searchKey])
        let result: Search? = storageManager.get(request: request).first
        return result
    }
    
    func contains(searchKey: String) -> Bool {
        return find(searchKey: searchKey) != nil
    }

    func remove(searchKey: String) -> Bool {
        let objects = getAll()
        
        if let idx = objects.firstIndex(where: { $0.key == searchKey }) {
            do {
                try storageManager.delete(object: objects[idx])
                return true
            } catch {
                print("Error while deleting \(searchKey): \(error)")
            }
        }
        
        return false
    }
    
    func update(searchKey: String, completion: @escaping ((Search) -> Void)) {
        guard let existingSearch = find(searchKey: searchKey) else { return }
        existingSearch.setValue(Date.now, forKey: "date")
        do {
            try storageManager.save()
            completion(existingSearch)
            return
        } catch {
            print("Error while updating \(searchKey): \(error)")
        }
    }

}

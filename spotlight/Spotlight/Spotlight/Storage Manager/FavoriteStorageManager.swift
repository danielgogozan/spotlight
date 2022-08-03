//
//  FavoriteStorageManager.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 06.04.2022.
//

import Foundation
import CoreData

final class FavoriteStorageManager {
    
    static let shared = FavoriteStorageManager()
    var storageManager: StorageManager!
    
    private init() {
        self.storageManager = StorageManager.shared
    }
    
    // MARK: - Base API
    func save(article: Article, completion: @escaping (Bool) -> Void) {
        let persistedArticle = PersistedArticle(context: storageManager.context)
        persistedArticle.convert(article: article, with: storageManager.context)
        
        do {
            try storageManager.save()
            completion(true)
        } catch {
            print("Error while saving \(article): \(error)")
            completion(false)
        }
    }
    
    func update(with article: Article, completion: @escaping (Bool, Bool) -> Void) {
        if isAlreadyPersisted(article) {
            completion(remove(using: article), false)
        } else {
            save(article: article, completion: { success in
                completion(success, true)
            })
        }
    }
    
    func getAll() -> [Article] {
        let results = getAllPersistedArticles()
        return results.compactMap { $0.convertToArticle() }
    }
    
    func filter(by text: String) -> [Article] {
        let fetchRequest = PersistedArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title CONTAINS %@", argumentArray: [text])
        let result = storageManager.get(request: fetchRequest)
        
        return result.compactMap { $0.convertToArticle() }
    }
    
}

// MARK: - Extra API
extension FavoriteStorageManager {
    
    func isAlreadyPersisted(_ article: Article) -> Bool {
        let fetchRequest = PersistedArticle.fetchRequest()
        // appareantly source is not a unique key for every article, hence we will consider the title of the article as being part of source.name
        fetchRequest.predicate = NSPredicate(format: "source.id == %@ && source.name == %@", argumentArray: [article.source.id as Any, article.mockedSourceName])
        do {
            return try storageManager.context.count(for: fetchRequest) > 0
        } catch {
            print("Error while checking if article is already persisted.")
            return false
        }
    }
    
    func find(using article: Article) -> PersistedArticle? {
        let fetchRequest = PersistedArticle.fetchRequest()
        // appareantly source is not a unique key for every article, hence we will consider the title of the article as being part of source.name
        fetchRequest.predicate = NSPredicate(format: "source.id == %@ && source.name == %@", argumentArray: [article.source.id as Any, article.mockedSourceName])
        return storageManager.get(request: fetchRequest).first
    }
    
    func getAllPersistedArticles() -> [PersistedArticle] {
        return storageManager.get(request: PersistedArticle.fetchRequest())
    }
    
    func remove(using article: Article) -> Bool {
        guard let persistedArticle = find(using: article) else { return false }
        
        do {
            try storageManager.delete(object: persistedArticle)
            return true
        } catch {
            print("Error while deleting {\(article.source.id ?? ""), \(article.source.name) \(article.title)}: \(error)")
        }
        
        return false
    }
    
}

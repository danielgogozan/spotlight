//
//  StorageManager.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 30.03.2022.
//

import Foundation
import UIKit
import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // this context executes on a private queue aka background queue, in order to increase app performance
    let context: NSManagedObjectContext
    
    private init() {
        // swiftlint:disable force_cast
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        // swiftlint:enable force_cast
    }
    
    func save() throws {
        try context.save()
    }
    
    func delete<T: NSManagedObject>(object: T) throws {
        context.delete(object)
        try save()
    }
    
    func get<T>(request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            print("Error while fetching \(request.description): \(error)")
        }
        return []
    }
    
}

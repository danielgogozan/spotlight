//
//  Source.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 12.04.2022.
//

import Foundation
import CoreData

@objc(PersistedSource)
public class PersistedSource: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var name: String
    @NSManaged public var article: PersistedArticle?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedSource> {
      return NSFetchRequest<PersistedSource>(entityName: "PersistedSource")
    }
    
    @nonobjc func convert(source: Source?, mockedSourceName: String, with context: NSManagedObjectContext) {
        guard let source = source else { return }
        self.id = source.id
        self.name = mockedSourceName
    }
}

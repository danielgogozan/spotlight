//
//  PersistedArticle+CoreData.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 12.04.2022.
//

import Foundation
import CoreData

@objc(PersistedArticle)
public class PersistedArticle: NSManagedObject {
    @NSManaged var author: String?
    @NSManaged var title: String?
    @NSManaged var desc: String?
    @NSManaged var url: String?
    @NSManaged var imgUrl: String?
    @NSManaged var publishedAt: String?
    @NSManaged var source: PersistedSource?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersistedArticle> {
        return NSFetchRequest<PersistedArticle>(entityName: "PersistedArticle")
    }
    
    @nonobjc func convert(article: Article, with context: NSManagedObjectContext) {
        self.author = article.author
        self.title = article.title
        self.desc = article.description
        self.publishedAt = article.publishedAt
        self.imgUrl = article.imageUrl
        self.source = PersistedSource(context: context)
        source?.convert(source: article.source, mockedSourceName: article.mockedSourceName, with: context)
    }
    
    @nonobjc func convertToArticle() -> Article {
        var article = Article()
        article.author = self.author
        article.title = self.title ?? ""
        article.description = self.desc
        article.publishedAt = self.publishedAt
        article.imageUrl = self.imgUrl
        
        let sourceName = String(self.source?.name.split(separator: "#")[0] ?? "")
        article.source = Source(id: self.source?.id, name: sourceName)
        return article
    }
}

//
//  StoryEntity+CoreDataProperties.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 12-04-25.
//
//

import Foundation
import CoreData


extension StoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoryEntity> {
        return NSFetchRequest<StoryEntity>(entityName: "StoryEntity")
    }

    @NSManaged public var by: String?
    @NSManaged public var title: String?
    @NSManaged public var id: Int32
    @NSManaged public var time: Int64
    @NSManaged public var score: Int32
    @NSManaged public var url: String?
    @NSManaged public var type: String?

}

extension StoryEntity : Identifiable {

}

extension StoryEntity: ToStoryProtocol {
    func toStory() -> Story {
        return Story(
            by: self.by,
            title: self.title,
            id: self.id,
            time: self.time,
            score: self.score,
            url: self.url)
    }
}

//
//  DataBaseService.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 12-04-25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "StoredModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error al cargar Core Data: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}


final class DataBaseService: DataBaseServiceProtocol {
    private let context = CoreDataManager.shared.context
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error when save context: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSavedStories() -> [Story] {
        let fetchRequest: NSFetchRequest<StoryEntity> = StoryEntity.fetchRequest()
        do {
            let stories = try context.fetch(fetchRequest)
            return Array(stories).map { $0.toStory() }
        } catch {
            print("Error al obtener usuarios: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveStory(story: Story) {
        let newStory = StoryEntity(context: context)
        newStory.id = story.id
        newStory.title = story.title
        newStory.url = story.url
        newStory.time = story.time
        newStory.score = story.score ?? 0
        newStory.by = story.by
        save()
    }
}

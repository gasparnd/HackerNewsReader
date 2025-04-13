//
//  SaveStoryProtocol.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 13-04-25.
//

import Foundation

protocol SaveStoryUseCaseProtocol {
    func saveStory(story: Story) -> Void
}

final class SaveStoryUseCase: SaveStoryUseCaseProtocol {
    let repository: StoriesRepository
    
    init(repository: StoriesRepository = StoriesRepositoryImpl()) {
        self.repository = repository
    }
    
    func saveStory(story: Story) {
        repository.saveStory(story)
    }
}

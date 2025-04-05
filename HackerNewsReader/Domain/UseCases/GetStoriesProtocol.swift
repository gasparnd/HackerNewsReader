//
//  GetStoriesProtocol.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 05-04-25.
//

import Foundation

protocol GetStoriesUseCaseProtocol {
    func getStories() async throws -> [Story]
}

final class GetStoriesUseCase: GetStoriesUseCaseProtocol {
    let repository: StoriesRepository
    
    init(repository: StoriesRepository = StoriesRepositoryImpl()) {
        self.repository = repository
    }
    
    func getStories() async throws -> [Story] {
        let data = try await repository.getRecentStories()
        return data
    }
    
}

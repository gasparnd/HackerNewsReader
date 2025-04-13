//
//  GetStoriesProtocol.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 05-04-25.
//

import Foundation

protocol GetStoriesUseCaseProtocol {
    func getStories(type: StoryType) async throws -> [Story]
    func getJobs() async throws -> [Story]
    func getSavedStories() -> [Story]
}

final class GetStoriesUseCase: GetStoriesUseCaseProtocol {
    let repository: StoriesRepository
    
    init(repository: StoriesRepository = StoriesRepositoryImpl()) {
        self.repository = repository
    }
    
    func getStories(type: StoryType) async throws -> [Story] {
        switch type {
        case .latest:
            let data = try await repository.getRecentStories()
            return data
        case .trending:
            let data = try await repository.getTrendingStories()
            return data
        }
    }
    
    func getJobs() async throws -> [Story] {
        let data = try await repository.getJobList()
        return data
    }
    
    func getSavedStories() -> [Story] {
        let stories = repository.getSavedStories()
        return stories
    }
    
}

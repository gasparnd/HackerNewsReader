//
//  GetStoriesProtocol.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 05-04-25.
//

import Foundation

protocol GetStoriesUseCaseProtocol {
    func getStories(type: StoryType, isRefreshing: Bool) async throws -> [Story]
    func getJobs(isRefreshing: Bool) async throws -> [Story]
    func getSavedStories() -> [Story]
}

final class GetStoriesUseCase: GetStoriesUseCaseProtocol {
    let repository: StoriesRepository
    
    init(repository: StoriesRepository = StoriesRepositoryImpl()) {
        self.repository = repository
    }
    
    func getStories(type: StoryType, isRefreshing: Bool = false) async throws -> [Story] {
        switch type {
        case .latest:
            let data = try await repository.getRecentStories(isRefreshing: isRefreshing)
            return data
        case .trending:
            let data = try await repository.getTrendingStories(isRefreshing: isRefreshing)
            return data
        }
    }
    
    func getJobs(isRefreshing: Bool = false) async throws -> [Story] {
        let data = try await repository.getJobList(isRefreshing: isRefreshing)
        return data
    }
    
    func getSavedStories() -> [Story] {
        let stories = repository.getSavedStories()
        return stories
    }
    
}

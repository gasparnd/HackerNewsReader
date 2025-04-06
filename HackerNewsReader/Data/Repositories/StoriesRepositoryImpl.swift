//
//  StoriesRepositoryImpl.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

final class StoriesRepositoryImpl: StoriesRepository {
    
    let apiClient: APIClient
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getStoryDetails(id: Int) async throws -> Story {
        let story: Story = try await apiClient.request(endpoint: .storyDetails(id: id))
        return story
    }
    
    func getRecentStories() async throws -> [Story] {
        let storieIds: [Int] = try await apiClient.request(endpoint: .recentStories)
        if storieIds.isEmpty {
            return []
        }
        
        let firstIDs = Array(storieIds.prefix(20))
        
        var stories: [Story] = []
        
        // Llamadas en paralelo
        try await withThrowingTaskGroup(of: Story.self) { group in
            for id in firstIDs {
                group.addTask {
                    try await self.getStoryDetails(id: id)
                }
            }
            
            for try await post in group {
                stories.append(post)
            }
        }
        
        return stories.sorted { $0.time > $1.time }
    }
    
    func getJobList() async throws -> [Story] {
        let jobIds: [Int] = try await apiClient.request(endpoint: .jobs)
        return []
    }
    
}

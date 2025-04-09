//
//  StoriesRepositoryImpl.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

final class StoriesRepositoryImpl: StoriesRepository {
    
    let apiClient: APIClient
    
    private var cachedRecentStoryIDs: [Int] = []
    private var cachedTrendingStoryIDs: [Int] = []
    private var currentPage = 0
    private let pageSize = 20
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getStoryDetails(id: Int) async throws -> Story {
        let story: Story = try await apiClient.request(endpoint: .storyDetails(id: id))
        return story
    }
    
    func getRecentStories() async throws -> [Story] {
        if cachedRecentStoryIDs.isEmpty {
            cachedTrendingStoryIDs = []
            cachedRecentStoryIDs = try await apiClient.request(endpoint: .recentStories)
        }
        
        let start = currentPage * pageSize
        let end = min(start + pageSize, cachedRecentStoryIDs.count)
        guard start < end else { return [] }
        
        let pageIDs = Array(cachedRecentStoryIDs[start..<end])
        currentPage += 1
        
        var stories: [Story] = []
        
        try await withThrowingTaskGroup(of: Story.self) { group in
            for id in pageIDs {
                group.addTask {
                    try await self.getStoryDetails(id: id)
                }
            }
            
            for try await story in group {
                stories.append(story)
            }
        }
        
        return stories.sorted { $0.time > $1.time }
    }
    
    func getTrendingStories() async throws -> [Story] {
        if cachedTrendingStoryIDs.isEmpty {
            cachedRecentStoryIDs = []
            cachedTrendingStoryIDs = try await apiClient.request(endpoint: .topStories)
        }
        
        let start = currentPage * pageSize
        let end = min(start + pageSize, cachedTrendingStoryIDs.count)
        guard start < end else { return [] }
        
        let pageIDs = Array(cachedTrendingStoryIDs[start..<end])
        currentPage += 1
        
        var stories: [Story] = []
        
        try await withThrowingTaskGroup(of: Story.self) { group in
            for id in pageIDs {
                group.addTask {
                    try await self.getStoryDetails(id: id)
                }
            }
            
            for try await story in group {
                stories.append(story)
            }
        }
        
        return stories.sorted { $0.time > $1.time }
    }
    
    
    func getJobList() async throws -> [Story] {
        let jobIds: [Int] = try await apiClient.request(endpoint: .jobs)
        return []
    }
    
}

//
//  StoriesRepositoryImpl.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

final class StoriesRepositoryImpl: StoriesRepository {
    
    let apiClient: APIClient
    let dataBaseService: DataBaseServiceProtocol
    
    private var cachedRecentStoryIDs: [Int] = []
    private var cachedTrendingStoryIDs: [Int] = []
    private var currentPage = 0
    private let pageSize = 20
    
    private var cachedJobIDs: [Int] = []
    private var jobsCurrentPage = 0
    private let jobsPageSize = 20
    
    init(apiClient: APIClient = APIClient(), dataBaseService: DataBaseServiceProtocol = DataBaseService()) {
        self.apiClient = apiClient
        self.dataBaseService = dataBaseService
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
        if cachedJobIDs.isEmpty {
            cachedJobIDs = try await apiClient.request(endpoint: .jobs)
        }
        let start = jobsCurrentPage * jobsPageSize
        let end = min(start + jobsPageSize, cachedJobIDs.count)
        guard start < end else { return [] }
        
        let pageIDs = Array(cachedJobIDs[start..<end])
        jobsCurrentPage += 1
        
        var jobs: [Story] = []
        
        try await withThrowingTaskGroup(of: Story.self) { group in
            for id in pageIDs {
                group.addTask {
                    try await self.getStoryDetails(id: id)
                }
            }
            
            for try await story in group {
                jobs.append(story)
            }
        }
        
        return jobs.sorted { $0.time > $1.time }
    }
    
    func getSavedStories() -> [Story] {
        let savedStories = dataBaseService.fetchSavedStories()
        return savedStories
    }
    
    func saveStory(_ story: Story) {
        return dataBaseService.saveStory(story: story)
    }
    
}

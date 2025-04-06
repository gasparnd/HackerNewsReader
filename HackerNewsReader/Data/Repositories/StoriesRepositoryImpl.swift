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
    
    private var cachedStoryIDs: [Int] = []
    private var currentPage = 0
    private let pageSize = 20

    func getRecentStories() async throws -> [Story] {
        if cachedStoryIDs.isEmpty {
            cachedStoryIDs = try await apiClient.request(endpoint: .recentStories)
        }

        let start = currentPage * pageSize
        let end = min(start + pageSize, cachedStoryIDs.count)
        guard start < end else { return [] }

        let pageIDs = Array(cachedStoryIDs[start..<end])
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

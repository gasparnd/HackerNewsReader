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
    
    func getRecentStories() async throws -> [Story] {
        let storieIds: [Int] = try await apiClient.request(endpoint: .recentStories)
        print(storieIds)
        if storieIds.isEmpty {
            return []
        }
        
        return []
    }
    
    func getJobList() async throws -> [Job] {
        return []
    }
    
    
}

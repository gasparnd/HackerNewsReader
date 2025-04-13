//
//  StoriesRepository.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

protocol StoriesRepository {
    func getRecentStories(isRefreshing: Bool) async throws -> [Story]
    func getTrendingStories(isRefreshing: Bool) async throws -> [Story]
    func getJobList(isRefreshing: Bool) async throws -> [Story]
    func getStoryDetails(id: Int) async throws -> Story
    func getSavedStories() -> [Story]
    func saveStory(_ story: Story) -> Void
}

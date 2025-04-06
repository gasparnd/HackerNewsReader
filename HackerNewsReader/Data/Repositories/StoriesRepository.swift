//
//  StoriesRepository.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

protocol StoriesRepository {
    func getRecentStories() async throws -> [Story]
    func getJobList() async throws -> [Story]
    func getStoryDetails(id: Int) async throws -> Story
}

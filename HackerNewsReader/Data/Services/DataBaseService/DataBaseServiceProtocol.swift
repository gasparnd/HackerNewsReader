//
//  DataBaseServiceProtocol.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 12-04-25.
//

import Foundation

protocol DataBaseServiceProtocol {
    func fetchSavedStories() -> [Story]
    func saveStory(story: Story) -> Void
}

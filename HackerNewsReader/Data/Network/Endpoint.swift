//
//  Endpoint.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum Endpoint {
    case recentStories
    case jobs
    case itemDetails(id: Int)
    
    var url: URL {
        let baseURL = "https://hacker-news.firebaseio.com/v0"
        
        switch self {
        case .recentStories:
            return URL(string: "\(baseURL)/newstories.json")!
        case .jobs:
            return URL(string: "\(baseURL)/jobstories.json")!
        case .itemDetails(let id):
            return URL(string: "\(baseURL)/item/\(id).json")!
        }
    }
    var method: HTTPMethod { return .get }
}

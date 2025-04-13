//
//  StoryType.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 07-04-25.
//

import Foundation

enum StoryType: String, CaseIterable {
    case latest = "Latest"
    case trending = "Trending"
    
    var endpointName: Endpoint {
        switch self {
        case .trending: return Endpoint.topStories
        case .latest: return Endpoint.recentStories
        }
    }
}

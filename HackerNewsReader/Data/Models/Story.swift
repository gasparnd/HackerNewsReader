//
//  Story.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

struct Story: Codable {
    let by: String
    let dead: Bool
    let id: Int
    let descendants: Int
    let kinds: [Id]
    let score: Int
    let time: Int
    let url: String
}

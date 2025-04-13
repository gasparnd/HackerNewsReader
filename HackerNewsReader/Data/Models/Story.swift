//
//  Story.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 03-04-25.
//

import Foundation

struct Story: Codable {
    let by: String?
    let title: String?
    let id: Int32
    let time: Int64
    let score: Int32?
    let url: String?
}

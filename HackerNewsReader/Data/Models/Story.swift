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
    let id: Int
    let time: Int
    let url: String?
}

//
//  DateFormat.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import Foundation

func timeAgo(from unixTime: TimeInterval) -> String {
    let postDate = Date(timeIntervalSince1970: unixTime)
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    return formatter.localizedString(for: postDate, relativeTo: Date())
}


//
//  UrlFormat.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import Foundation

func extractDomain(from urlString: String?) -> String {
    guard let urlString = urlString,
          let url = URL(string: urlString),
          let host = url.host else {
        return ""
    }
    
    return host.replacingOccurrences(of: "www.", with: "")
}

//
//  Platform.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/10/21.
//

import Foundation

struct PlatformSearchResult: Codable{
    var released_at: String?
    var platform: Platform
}

struct PlatformSelection: Codable{
    var results: [Platform]
}

struct Platform: Codable{
    var id: Int
    var name: String
}

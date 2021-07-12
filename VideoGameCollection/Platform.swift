//
//  Platform.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/10/21.
//

import Foundation

struct PlatformSearchResult: Codable, Hashable{
    var released_at: String?
    var platform: Platform
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(released_at)
        hasher.combine(platform)
    }
}

struct PlatformSelection: Codable{
    var results: [Platform]
}

struct Platform: Codable, Hashable{
    var id: Int
    var name: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

//
//  Platform.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/10/21.
//

import Foundation

struct PlatformResult: Codable{
    var count: Int
    var results: [Platform]
}

struct Platform: Codable{
    var id: Int
    var name: String
}

//
//  Platform.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/10/21.
//

//import the following frameworks...
import Foundation

/**
 Struct for decoding JSON platform data for when a user searches for a game
 This struct contains the results for when a user searches for a game for what platforms this game is on
 Actual platform data is stored, but is not readable through this struct, as that is the Platform struct
 */
struct PlatformSearchResult: Codable, Hashable{
    var released_at: String?
    var platform: Platform      //platform the game was released on
    
    //hash function for making this function compliant with the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(released_at)
        hasher.combine(platform)
    }
}

/**
 Struct to be used when decoding JSON data for the platform filter picker for the AddGameView screen
 This is only to be used for that picker's data, and nothing else
 */
struct PlatformSelection: Codable{
    var results: [Platform]
}

/**
 Struct that holds data for the platform a game is on
 This is primarily used when decoding data in the AddGameView
 */
struct Platform: Codable, Hashable{
    var id: Int     //id of the platform
    var name: String    //name of the platform
    
    //hash function for making this function compliant with the Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

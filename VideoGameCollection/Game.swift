//
//  Game.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

//import the following resources...
import Foundation

/**
 GameResults: struct used when encoding/decoding JSON search results for the adding games through the AddGameView
 Note: this struct should not be used when processing actual results, it is only meant as a container to hold them for API decoding purposes
 Results should be used out of the "results" array, which is full of game information
 Reference the RAWG online API documentation for more information
 */
struct GameResults: Codable{
    var count: Int  //number of results returned
    var results: [GameSearch]   //array of game data
    
    init() {
        //initialize both to just be essentially "empty" properties (0 and [] respectively)
        self.count = 0
        self.results = []
    }
}

/**
 GameSearch: struct to be used when actually reading game data results when searching for games through the AddGameView
 Reference the RAWG online API documentation for more information about parameters
 */
struct GameSearch: Codable, Identifiable{
    enum codingKey: CodingKey {
        case id, name, platforms
    }
    var id: Int     //id of the game
    let name: String    //name of the game
    let platforms: [PlatformSearchResult]   //platforms the game supports
}

struct GameDetails: Codable {
    var id: Int
    var name: String
    var description: String
    var background_image: String
    var esrb_rating: esrb_rating?
}

struct esrb_rating: Codable{
    var id: Int
    var name: String
}

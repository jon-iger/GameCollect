//
//  Game.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/9/21.
//

import Foundation
import CloudKit

/**
 A single individual game record
 title: title of the game
 gameId: id of the game
 recordId: record id of the game in the cloud
 dateAdded: date that the user added the object to the collection
 */
class Game: ObservableObject, Hashable{
    static func == (lhs: Game, rhs: Game) -> Bool {
        if lhs.gameId == rhs.gameId{
            return true
        }
        else{
            return false
        }
    }
    
    var title: String!
    var gameId: Int!
    var recordID: CKRecord.ID!
    var dateAdded: Date!
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gameId)
    }
}

/**
 Struct used when encoding/decoding JSON search results for the adding games through the AddGameView
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
 Struct to be used when actually reading game data results when searching for games through the AddGameView
 Reference the RAWG online API documentation for more information about parameters
 */
struct GameSearch: Codable, Identifiable{
    var id: Int     //id of the game
    let name: String    //name of the game
    let metacritic: Int?
    let esrb_rating: esrb_rating?
    let platforms: [PlatformSearchResult]   //platforms the game supports
}

/**
 Details for a single game that is found in a search
 id: id of the game
 name: name of the game
 description: description of the game
 metacritic: metacritic rating of the game
 released: string value of release data
 background_image: URL of the background image for game page
 esrb_rating-game rating information
 platforms: platforms the game is on
 */
struct GameDetails: Codable {
    var id: Int
    var name: String
    var description: String
    var metacritic: Int?
    var released: String
    var background_image: String
    var esrb_rating: esrb_rating?
    var platforms: [PlatformSearchResult]
}

/**
 Codable struct for ESRB rating objects
 id: id of the rating
 name: name of the rating
 */
struct esrb_rating: Codable{
    var id: Int
    var name: String
}

/**
 Object to be used to store individual game screenshots found
 count: the number of screenshots available
 results: the screenshots that were found
 */
struct GameScreenshot: Codable{
    var count: Int
    var results: [ScreenshotImage]
    
    init(){
        self.count = 0
        self.results = []
    }
    
    /**
     One individual screenshot game image
     id: id of the image
     image: string URL of the image
     width: integer dimension
     height: integer dimension
     */
    struct ScreenshotImage: Codable, Hashable{
        var id: Int
        var image: String
        var width: Int
        var height: Int
    }
}

/**
 Results returned for stores found from a search
 count: number of stores found
 results: GameStore objects stored
 */
struct GameDetailsStoreResults: Codable{
    var count: Int
    var results: [GameStore]
    
    struct GameStore: Codable{
        var id: Int
        var game_id: Int
        var store_id: Int
        var url: String
    }
}

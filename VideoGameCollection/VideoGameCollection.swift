//
//  VideoGameCollection.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

import Foundation

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("gameSave").appendingPathExtension("json")

class VideoGameCollection: ObservableObject, Codable{
    enum codingKey: CodingKey{
        case gameCollection
    }
    var gameCollection: [Game]
    
    init(gameCollection: [Game]){
        self.gameCollection = gameCollection
    }
    
    init(){
        self.gameCollection = []
    }
    
    static func saveToFile(basicObject: VideoGameCollection){
        let encodedObject = try? JSONEncoder().encode(basicObject)
        try? encodedObject?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> VideoGameCollection{
        var loadedData = VideoGameCollection()
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedSaveData = try? Data(contentsOf: archiveURL),
           let decodedSaveData = try? propertyListDecoder.decode(VideoGameCollection.self, from: retrievedSaveData) {
            loadedData = decodedSaveData
        }
        return loadedData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKey.self)
        try container.encode(gameCollection, forKey: .gameCollection)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKey.self)
        gameCollection = try container.decode([Game].self, forKey: .gameCollection)
    }
}

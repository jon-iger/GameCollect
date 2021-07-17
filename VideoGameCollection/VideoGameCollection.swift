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
    @Published var gameCollection: [Int]
    
    init(){
        self.gameCollection = []
    }
    
    static func saveToFile(basicObject: VideoGameCollection){
        let encodedObject = try? JSONEncoder().encode(basicObject)
        try? encodedObject?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> VideoGameCollection{
        var loadedData = VideoGameCollection()
        if let retrievedSaveData = try? Data(contentsOf: archiveURL),
           let decodedSaveData = try? JSONDecoder().decode(VideoGameCollection.self, from: retrievedSaveData) {
            loadedData = decodedSaveData
            for game in loadedData.gameCollection{
                print(game)
            }
        }
        return loadedData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKey.self)
        try container.encode(gameCollection, forKey: .gameCollection)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKey.self)
        gameCollection = try container.decode([Int].self, forKey: .gameCollection)
    }
}

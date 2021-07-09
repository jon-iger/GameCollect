//
//  Game.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

import Foundation

class Game: Codable{
    enum codingKey: CodingKey {
        case id, title, genre, rating, developer, publisher, releaseDate, consoles
    }
    var id = UUID()
    let title: String
    let genre: String
    let rating: String
    let developer: String
    let publisher: String
    let releaseDate: Date
    let consoles: [String]
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: codingKey.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(genre, forKey: .genre)
        try container.encode(rating, forKey: .rating)
        try container.encode(developer, forKey: .developer)
        try container.encode(publisher, forKey: .publisher)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(consoles, forKey: .consoles)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKey.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        genre = try container.decode(String.self, forKey: .genre)
        rating = try container.decode(String.self, forKey: .rating)
        developer = try container.decode(String.self, forKey: .developer)
        publisher = try container.decode(String.self, forKey: .publisher)
        releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        consoles = try container.decode([String].self, forKey: .consoles)
    }
}

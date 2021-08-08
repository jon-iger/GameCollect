//
//  VideoGameCollectionApp.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI

@main
struct VideoGameCollectionApp: App {
    let gameCollection: VideoGameCollection = VideoGameCollection.loadiCloudGames()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameCollection)
        }
    }
}

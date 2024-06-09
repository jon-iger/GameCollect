//
//  VideoGameCollectionApp.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/7/21.
//

import SwiftUI

@main
struct VideoGameCollectionApp: App {
    let gameCollection: CloudContainer = CloudContainer.loadiCloudGames()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameCollection)
        }
    }
}

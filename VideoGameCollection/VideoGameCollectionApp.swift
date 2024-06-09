//
//  VideoGameCollectionApp.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/7/21.
//

import SwiftUI

@main
struct VideoGameCollectionApp: App {
    let gameCollection: CloudContainer = CloudContainer.loadCloudGames()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(gameCollection)
        }
    }
}

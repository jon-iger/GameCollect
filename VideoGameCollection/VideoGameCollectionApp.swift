//
//  VideoGameCollectionApp.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI

@main
struct VideoGameCollectionApp: App {
    let persistenceController = PersistenceController.shared
    let gameCollection: VideoGameCollection = VideoGameCollection.loadFromFile()
    let universalBarcodeObject: BarcodeScanCode = BarcodeScanCode()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gameCollection)
                .environmentObject(universalBarcodeObject)
        }
    }
}

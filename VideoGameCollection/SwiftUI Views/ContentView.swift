//
//  ContentView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var gameObject: VideoGameCollection
    @State var showingSheet = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(gameObject.gameCollection, id: \.self){ game in
                    GameCollectionRow(id: game)
                }
                .onDelete(perform: deleteGame)
            }
            .navigationBarTitle("Game Collection")
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink("+", destination: AddGameView()))
        }
    }
    func deleteGame(at offsets: IndexSet) {
        gameObject.gameCollection.remove(atOffsets: offsets)
        VideoGameCollection.saveToFile(basicObject: gameObject)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

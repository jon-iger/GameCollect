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
            }
            .navigationBarTitle("Game Collection")
            .navigationBarItems(trailing: NavigationLink("+", destination: AddGameView()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

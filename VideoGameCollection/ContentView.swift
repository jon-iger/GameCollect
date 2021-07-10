//
//  ContentView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var gameObject: VideoGameCollection
    @State var showingSheet = false
    
    var body: some View {
        NavigationView{
            List{
                if gameObject.gameCollection.count == 0{
                    Text("Add some games!")
                }
                else{
                    ForEach(gameObject.gameCollection){ game in
                        VStack{
                            Text(game.title)
                        }
                    }
                }
            }
            .navigationBarTitle("Game Collection")
            .navigationBarItems(trailing: Button("+"){
                showingSheet = true
            })
        }
        .sheet(isPresented: $showingSheet, content: {
            AddGameView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

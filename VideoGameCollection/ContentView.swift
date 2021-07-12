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
            VStack{
                if gameObject.gameCollection.count == 0{
                    Text("Add some games!")
                    Image(systemName: "gamecontroller")
                }
                else{
                    List{
                        ForEach(gameObject.gameCollection){ game in
                            VStack{
                                
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Game Collection")
            .navigationBarItems(trailing: NavigationLink("+", destination: AddGameView()))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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
    var isEmpty: Bool{
        if gameObject.gameCollection.count == 0{
            return true
        }
        else{
            return false
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                if isEmpty{
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

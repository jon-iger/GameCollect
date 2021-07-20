//
//  ContentView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI
import CoreData

/**
 View to display the user's current games in their collection
 */
struct ContentView: View {
    @EnvironmentObject var gameObject: VideoGameCollection  //environment object used for storing the current user
    @State var searchText = String()    //string used for holding the user's current search text
    
    //SwiftUI body
    var body: some View {
        TabView{
            NavigationView{
                VStack{
                    List{
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .padding(4)
                            TextField("Search", text: $searchText)
                            Spacer()
                            NavigationLink(destination: SortFilterView()){
                                Text("Sort")
                                    .padding(7)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                        ForEach(gameObject.gameCollection, id: \.self){ game in
                            GameCollectionRow(id: game)
                        }
                        .onDelete(perform: deleteGame)
                    }
                    .navigationBarTitle("Game Collection")
                    .navigationBarItems(trailing: EditButton())
                }
                GameDetailsView(id: UserDefaults.standard.integer(forKey: "lastViewedGame"))
            }
            .tabItem{
                Image(systemName: "gamecontroller")
                Text("Home")
            }
            NavigationView{
                AddGameView()
                GameDetailsView(id: UserDefaults.standard.integer(forKey: "lastViewedGame"))
            }
            .tabItem{
                Image(systemName: "plus")
                Text("Add")
            }
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

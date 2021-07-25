//
//  ContentView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/7/21.
//

import SwiftUI
import CoreData

let apiKey = "3c7897d6c00a4f0fae76833a5c8e743c"

/**
 View to display the user's current games in their collection
 */
struct ContentView: View {
    @EnvironmentObject var gameObject: VideoGameCollection  //environment object used for storing the current user
    @State var searchText = String()    //string used for holding the user's current search text
    @State var activeSearch = false
    @State var searchResults: [Int] = []
    @State var sortTitle = false
    
    //SwiftUI body
    var body: some View {
        let bindSearch = Binding<String>(
            //display displayText for the user to see
            get: {self.searchText},
            //when setting bindSearch string, use this...
            set: {
                searchResults = []
                activeSearch = true
                print("Setting")
                self.searchText = $0
                for game in gameObject.gameCollection{
                    if game.title.contains(searchText) && !searchResults.contains(game.id){
                        searchResults.append(game.id)
                    }
                }
                if self.searchText.isEmpty{
                    print("Is Empty")
                    activeSearch = false
                    searchResults = []
                }
            }
        )
        TabView{
            NavigationView{
                VStack{
                    List{
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .padding(4)
                            TextField("Search", text: bindSearch)
                                .onTapGesture {
                                    activeSearch = true
                                }
                        }
                        if !activeSearch{
                            ForEach(Array(gameObject.gameCollection), id: \.self){ game in
                                GameCollectionRow(id: game.id)
                            }
                            .onDelete(perform: deleteGame)
                        }
                        else{
                            ForEach(searchResults, id: \.self){ game in
                                GameCollectionRow(id: game)
                            }
                        }
                    }
                    .navigationBarTitle("Game Collection")
                    .navigationBarItems(leading: EditButton(), trailing:
                                            Menu{
                                                Button{
                                                    sortByDate()
                                                }
                                                label:{
                                                    Image(systemName: "clock")
                                                    Text("Recently Added")
                                                }
                                                Button{
                                                    print("Hi")
                                                }
                                                label:{
                                                    Image(systemName: "gamecontroller")
                                                    Text("Platform")
                                                }
                                                Button{
                                                    sortByTitle()
                                                }
                                                label:{
                                                    Image(systemName: "abc")
                                                    Text("Title")
                                                }
                                            } label:{
                                                Image(systemName: "ellipsis.circle")
                                            }
                    )
                }
                GameDetailsView(id: UserDefaults.standard.integer(forKey: "lastViewedGame"))
            }
            .tabItem{
                Image(systemName: "house")
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
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
    func deleteGame(at offsets: IndexSet) {
        gameObject.gameCollection.remove(atOffsets: offsets)
        VideoGameCollection.saveToFile(basicObject: gameObject)
    }
    func sortByTitle(){
        gameObject.gameCollection.sort(by: {$0.title < $1.title})
        VideoGameCollection.saveToFile(basicObject: gameObject)
    }
    func sortByDate(){
        gameObject.gameCollection.sort(by: {$0.dateAdded > $1.dateAdded})
        VideoGameCollection.saveToFile(basicObject: gameObject)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

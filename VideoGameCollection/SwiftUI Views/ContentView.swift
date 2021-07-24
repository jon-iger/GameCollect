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
    @EnvironmentObject var currentCollectionInfo: Game
    @State var searchText = String()    //string used for holding the user's current search text
    @State var activeSearch = false
    @State var searchResults: [Int] = []
    @State var displayResults: [Int] = []
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
                for name in currentCollectionInfo.currentCollection.keys{
                    if name.contains(searchText) && !searchResults.contains(currentCollectionInfo.currentCollection[name]!){
                        print("appending \(name)")
                        searchResults.append(currentCollectionInfo.currentCollection[name]!)
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
                            Spacer()
                            NavigationLink(destination: SortFilterView()){
                                Text("Sort")
                                    .padding(7)
                                    .background(Color.gray)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                        if !activeSearch{
                            ForEach(displayResults, id: \.self){ game in
                                GameCollectionRow(id: game)
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
                                                    print("Hi")
                                                }
                                                label:{
                                                    Image(systemName: "clock")
                                                    Text("Recently Added")
                                                }
                                                Button{
                                                    print("Hi")
                                                }
                                                label:{
                                                    Image(systemName: "arrow.up.arrow.down")
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
                    .onAppear{
                        displayResults = Array(gameObject.gameCollection.keys)
                        print(displayResults.count)
                    }
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
        displayResults.remove(atOffsets: offsets)
        gameObject.gameCollection.removeValue(forKey: offsets.first!)
        VideoGameCollection.saveToFile(basicObject: gameObject)
    }
    func sortByTitle(){
        let sortedStrings = currentCollectionInfo.currentCollection.keys.sorted()
        var returnArray: [Int] = []
        for string in sortedStrings{
            returnArray.append(currentCollectionInfo.currentCollection[string]!)
        }
        displayResults = returnArray
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

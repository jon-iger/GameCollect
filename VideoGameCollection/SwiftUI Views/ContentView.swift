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
    @EnvironmentObject var currentCollectionInfo: Game
    @State var searchText = String()    //string used for holding the user's current search text
    @State var activeSearch = false
    @State var searchResults: [Int] = []
    
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
                            ForEach(gameObject.gameCollection, id: \.self){ game in
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

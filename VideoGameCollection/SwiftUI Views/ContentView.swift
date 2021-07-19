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
    @Environment(\.horizontalSizeClass) var sizeClass
    @State var showingSheet = false
    @State var searchText = String()
    @State var searchSheet = false
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
                Text("Nothing Selected")
            }
            .tabItem{
                Image(systemName: "person.3")
                Text("Home")
            }
            NavigationView{
                AddGameView()
                Text("Nothing Selected")
            }
            .tabItem{
                Image(systemName: "person.3")
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

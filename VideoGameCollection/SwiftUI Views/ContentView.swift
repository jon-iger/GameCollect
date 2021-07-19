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
    @State var searchText = String()
    @State var searchSheet = false
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    HStack{
                        Button("Sort"){
                            searchSheet.toggle()
                        }
                        .padding(7)
                        .background(Color.gray)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        Image(systemName: "magnifyingglass")
                            .padding(4)
                        TextField("Search", text: $searchText)
                    }
                    ForEach(gameObject.gameCollection, id: \.self){ game in
                        GameCollectionRow(id: game)
                    }
                    .onDelete(perform: deleteGame)
                }
                .navigationBarTitle("Game Collection")
                .navigationBarItems(leading: EditButton(), trailing: NavigationLink("+", destination: AddGameView()))
            }
            .sheet(isPresented: $searchSheet, content: {
                SortFilterView()
            })
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

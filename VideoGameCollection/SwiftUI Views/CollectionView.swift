//
//  CollectionView.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/25/21.
//

import SwiftUI
import Foundation

struct CollectionView: View {
    @EnvironmentObject var gameObject: GameCollectionViewModel  //environment object used for storing the current user
    @State var viewModel = ViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        let bindSearch = Binding<String>(
            //display displayText for the user to see
            get: {viewModel.searchText},
            //when setting bindSearch string, use this...
            set: {
                viewModel.setBindSearch(string: $0, games: gameObject.gameCollection)
            }
        )
        NavigationView{
            if viewModel.canLoad{
                VStack{
                    if gameObject.gameCollection.count != 0{
                        if !viewModel.gridView{
                            List{
                                if viewModel.platformFilter{
                                    PlatformListView(platformDict: viewModel.platformDict)
                                }
                                else{
                                    HStack{
                                        Image(systemName: "magnifyingglass")
                                            .padding(4)
                                        TextField("Search", text: bindSearch)
                                            .onTapGesture {
                                                viewModel.activeSearch = true
                                            }
                                    }
                                    if !viewModel.activeSearch{
                                        ForEach(Array(gameObject.gameCollection), id: \.self){ game in
                                            GameCollectionRow(id: game.gameId)
                                        }
                                        .onDelete(perform: deleteGame)
                                    }
                                    else{
                                        ForEach(viewModel.searchResults, id: \.self){ gameId in
                                            GameCollectionRow(id: gameId)
                                        }
                                    }
                                }
                            }
                        }
                        else if viewModel.gridView{
                            ScrollView{
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                    TextField("Search", text: bindSearch)
                                        .onTapGesture {
                                            viewModel.activeSearch = true
                                        }
                                }
                                .padding(7)
                                LazyVGrid(columns: columns){
                                    ForEach(Array(gameObject.gameCollection), id: \.self){ game in
                                        GameCollectionGrid(id: game.gameId)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        Spacer()
                        Text("Welcome to Game Collect! Add some games to get started 🙂")
                            .padding()
                            .multilineTextAlignment(.center)
                        Image("Welcome Controller")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        Spacer()
                    }
                    
                }
                .navigationTitle("Game Collection")
                .navigationBarItems(leading: EditButton(), trailing:
                                        Menu{
                                            Section{
                                                Button{
                                                    viewModel.gridView = false
                                                }
                                                label:{
                                                    Image(systemName: "list.bullet")
                                                    Text("List View")
                                                }
                                                Button{
                                                    viewModel.gridView = true
                                                }
                                                label:{
                                                    Image(systemName: "square.grid.2x2")
                                                    Text("Grid View")
                                                }
                                            }
                                            Section{
                                                Button{
                                                    viewModel.platformFilter = false
                                                    sortByDate()
                                                }
                                                label:{
                                                    Image(systemName: "clock")
                                                    Text("Recently Added")
                                                }
                                                Button{
                                                    viewModel.platformFilter = true
                                                }
                                                label:{
                                                    Image(systemName: "gamecontroller")
                                                    Text("Platform")
                                                }
                                                Button{
                                                    viewModel.platformFilter = false
                                                    sortByTitle()
                                                }
                                                label:{
                                                    Image(systemName: "abc")
                                                    Text("Title")
                                                }
                                            }
                                        } label:{
                                            Image(systemName: "ellipsis.circle")
                                        }
                )
                if gameObject.gameCollection.isEmpty && UserDefaults.standard.integer(forKey: "lastViewedGame") == 0{
                    Spacer()
                    Text("Welcome to Game Collect! Add some games to get started 🙂")
                        .padding()
                        .multilineTextAlignment(.center)
                    Image("Welcome Controller")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                    Spacer()
                }
                else{
                    GameDetailsView(id: UserDefaults.standard.integer(forKey: "lastViewedGame"))
                }
            }
            else{
                VStack{
                    ActivityIndicator(shouldAnimate: $viewModel.shouldAnimate)
                    if !viewModel.shouldAnimate{
                        Text("Unable to display data. Either RAWG or your internet connection is offline. Try again later 😞.")
                    }
                }
            }
        }
        .onAppear{
            //check the status of the API and whether it's online or not. If offline, display something else instead
            handleOnAppear()
        }
    }
    func handleOnAppear() {
        viewModel.checkDatabaseStatus()
        viewModel.bingTest()
    }
    func deleteGame(at offsets: IndexSet) {
        gameObject.gameCollection.remove(atOffsets: offsets)
        //VideoGameCollection.saveToFile(basicObject: gameObject)
    }
    func sortByTitle(){
        gameObject.gameCollection.sort(by: {$0.title < $1.title})
    }
    func sortByDate(){
        gameObject.gameCollection.sort(by: {$0.dateAdded > $1.dateAdded})
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

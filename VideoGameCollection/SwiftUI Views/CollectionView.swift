//
//  CollectionView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/25/21.
//

import SwiftUI
import Foundation

struct CollectionView: View {
    @EnvironmentObject var gameObject: VideoGameCollection  //environment object used for storing the current user
    @State private var searchText = String()    //string used for holding the user's current search text
    @State private var activeSearch = false
    @State private var searchResults: [Int] = []
    @State private var gridView = false
    @State private var platformDict: [Platform:[Int]] = [:]
    @State private var platformFilter = false
    @State private var canLoad = true
    @State private var displayFailureAlert = false
    @State private var shouldAnimate = true
    @State private var confirmFailure = false
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
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
                    if game.title.contains(searchText) && !searchResults.contains(game.gameId){
                        searchResults.append(game.gameId)
                    }
                }
                if self.searchText.isEmpty{
                    print("Is Empty")
                    activeSearch = false
                    searchResults = []
                }
            }
        )
        NavigationView{
            if canLoad{
                VStack{
                    if gameObject.gameCollection.count != 0{
                        if !gridView{
                            List{
                                if platformFilter{
                                    PlatformListView(platformDict: self.platformDict)
                                }
                                else{
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
                                            GameCollectionRow(id: game.gameId)
                                        }
                                        .onDelete(perform: deleteGame)
                                    }
                                    else{
                                        ForEach(searchResults, id: \.self){ gameId in
                                            GameCollectionRow(id: gameId)
                                        }
                                    }
                                }
                            }
                        }
                        else if gridView{
                            ScrollView{
                                HStack{
                                    Image(systemName: "magnifyingglass")
                                        .padding(4)
                                    TextField("Search", text: bindSearch)
                                        .onTapGesture {
                                            activeSearch = true
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
                                                    gridView = false
                                                }
                                                label:{
                                                    Image(systemName: "list.bullet")
                                                    Text("List View")
                                                }
                                                Button{
                                                    gridView = true
                                                }
                                                label:{
                                                    Image(systemName: "square.grid.2x2")
                                                    Text("Grid View")
                                                }
                                            }
                                            Section{
                                                Button{
                                                    platformFilter = false
                                                    sortByDate()
                                                }
                                                label:{
                                                    Image(systemName: "clock")
                                                    Text("Recently Added")
                                                }
                                                Button{
                                                    platformFilter = true
                                                }
                                                label:{
                                                    Image(systemName: "gamecontroller")
                                                    Text("Platform")
                                                }
                                                Button{
                                                    platformFilter = false
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
                if gameObject.gameCollection.count == 0 && UserDefaults.standard.integer(forKey: "lastViewedGame") == 0{
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
                    ActivityIndicator(shouldAnimate: $shouldAnimate)
                    if !shouldAnimate{
                        Text("Unable to display data. Either RAWG or your internet connection is offline. Try again later 😞.")
                    }
                }
            }
        }
        .onAppear{
            //check the status of the API and whether it's online or not. If offline, display something else instead
            checkDatabaseStatus()
            bingTest()
        }
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
    /**
     Attempts to load sample data from the RAWG API. If this fails, the screen is stopped from rendering. Otherwise it can proceed
     parameters: none
     */
    func checkDatabaseStatus(){
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games?key=\(rawgAPIKey)&search="
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            canLoad = false
            shouldAnimate = false
            return
        }
        print("Starting decoding...in the check function")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                canLoad = true
                shouldAnimate = false
            } else  {
                print("Failed")
            }
        }.resume()  //call our URLSession
    }
    
    func bingTest(){
        //create the basic URL
        let urlString = "https://api.bing.microsoft.com/v7.0/images/search?q=mt+rainier"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            canLoad = false
            shouldAnimate = false
            return
        }
        print("Starting decoding...in the bing function")
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(bingSearchAPIKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if (statusCode == 200) {
                if let data = data{
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                }
                print("Everyone is fine in the bing function, file downloaded successfully.")
            } else  {
                print("Failed")
            }
        }.resume()  //call our URLSession
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}

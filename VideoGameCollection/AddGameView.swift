//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

import SwiftUI

struct AddGameView: View {
    @State var searchText = String()    //string sent into API calls with the search bar
    @State var displayText = String()   //string to be displayed to the user when typing in the search bar
    @State var gameResults: GameResults = GameResults()     //empty GameResults object that will later on store search results when used with the API
    @State var showExact: Bool = false      //boolean value to toggle "exact search" filter on or off
    @State var platformSelection = String()     //string holding the user's selection of console/platform filter
    @State var platformAPISelect = String()     //string holding the final string of the user's platform selection. This string must first be modified to have spaces removed from it with "-" character in it's place instead
    @State var platformDict = [:]       //empty dictionary that will hold the names and ids of the platforms supported in the API at that time
    @State var platformNames: [String] = []     //empty string array that will hold all of the names of the platforms supported by the API. Data is loaded into the array upon appearance of this view
    
    //initial body
    var body: some View {
        //custom binding for filtering out " " characters and replacing them with "-"
        let bindSearch = Binding<String>(
            //display displayText for the user to see
            get: { self.displayText},
            //when setting bindSearch string, use this...
            set: {
                //set the displayText property to the inputted value
                self.displayText = $0
                //convert what the user entered into a char array
                var charArray = Array(self.displayText)
                var index = 0   //variable for holding the current iteration of the below for loop
                //iterate through all the chars in the array, replacing every " " with "-" for valid API calls
                for char in charArray{
                    if char == " "{
                        charArray[index] = "-"
                    }
                    index += 1
                }
                //set the searchText property (as the thing to be sent to the API) equal to the new modified string
                searchText = String(charArray)
                //call the gameSearch (API call) function with the selected current states
                gameSearch(searchText, showExact, platformAPISelect)
            }
        )
        let bindPlatform = Binding<String>(
            get: { self.platformSelection},
            set: {
                self.platformSelection = $0
                var charArray = Array(self.platformSelection)
                var index = 0
                for char in charArray{
                    if char == " "{
                        charArray[index] = "-"
                    }
                    index += 1
                }
                platformAPISelect = String(charArray)
                gameSearch(searchText, showExact, platformAPISelect)
            }
        )
        let bindExact = Binding<Bool>(
            get: {self.showExact},
            set: {self.showExact = $0; gameSearch(searchText, showExact, platformAPISelect)}
        )
        Form{
            Section(header: Text("Filters")){
                Toggle("Exact Search", isOn: bindExact)
                Picker("Platform", selection: bindPlatform, content: { // <2>
                    ForEach(Array(platformDict.keys), id: \.self){ key in
                        Text(key.description).tag(key.description)
                    }
                })
            }
            TextField("Search", text: bindSearch)
                .padding()
            Section(header: Text("Results")){
                List(gameResults.results, id: \.id){ game in
                    GameResultRow(title: game.name, platformArray: game.platforms)
                }
            }
        }
        .navigationBarTitle("Add Game")
        .onAppear(perform: {
            loadPlatformSelection()
        })
    }
    
    //API note: use - character to subsitutue for space characters, as the API does not allow spaces in URLs (bad URL warnings will appear in the console if this is done)
    func gameSearch(_ searchTerm: String, _ searchExact: Bool, _ platformFilter: String) {
        let urlString = "https://api.rawg.io/api/games?key=3c7897d6c00a4f0fae76833a5c8e743c&search=\(searchTerm)&search_exact=\(searchExact)&platforms=\(platformDict[platformSelection]!)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                //let str = String(decoding: data, as: UTF8.self)
                //print(str)
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(GameResults.self, from: data){
                    for game in items.results {
                        print(game)
                    }
                    print("\n")
                    gameResults = items
                    return
                }
                
            }
        }.resume()
    }
    
    func loadPlatformSelection() {
        let urlString = "https://api.rawg.io/api/platforms?key=3c7897d6c00a4f0fae76833a5c8e743c"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                //let str = String(decoding: data, as: UTF8.self)
                //print(str)
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(PlatformSelection.self, from: data){
                    for platform in items.results {
                        print(platform)
                        platformDict[platform.name] = platform.id
                        platformNames.append(platform.name)
                    }
                    print("\n")
                    return
                }
                
            }
        }.resume()
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}

//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

//import the following frameworks...
import SwiftUI

struct AddGameView: View {
    @State var searchText = String()    //string sent into API calls with the search bar
    @State var displayText = String()   //string to be displayed to the user when typing in the search bar
    @State var gameResults: GameResults = GameResults()     //empty GameResults object that will later on store search results when used with the API
    @State var showExact: Bool = false      //boolean value to toggle "exact search" filter on or off
    @State var platformSelection = String()     //string holding the user's selection of console/platform filter
    @State var platformAPISelect = String()     //string holding the final string of the user's platform selection. This string must first be modified to have spaces removed from it with "-" character in it's place instead
    @State var showAnimation = false
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
        
        //custom binding for filtering out " " characters and replacing them with "-"
        let bindPlatform = Binding<String>(
            //display platformSelection (non-modded string) for the user to see
            get: { self.platformSelection},
            //when setting bindPlatform, use this...
            set: {
                //set the platformSelection property to the user input
                self.platformSelection = $0
                //convert what the user entered into a char array
                var charArray = Array(self.platformSelection)
                var index = 0   //variable for holding the current iteration of the below for loop
                //iterate through all the chars in the array, replacing every " " with "-" for valid API calls
                for char in charArray{
                    if char == " "{
                        charArray[index] = "-"
                    }
                    index += 1
                }
                //set the platformAPISelect property to equal the new modified string
                platformAPISelect = String(charArray)
                //call the gameSearch (API call) function with the selected current states
                gameSearch(searchText, showExact, platformAPISelect)
            }
        )
        
        //custom binding for toggling the "Exact Search" filter
        let bindExact = Binding<Bool>(
            //set the bindExact value to equal showExact
            get: {self.showExact},
            //set showExact to equal the current boolean, and call the gameSearch (API call) function with the selected current states
            set: {self.showExact = $0; gameSearch(searchText, showExact, platformAPISelect)}
        )
        
        //SwiftUI body
        Form{
            Section(header: Text("Filters")){
                Toggle("Exact Search", isOn: bindExact)
                Picker("Platform", selection: bindPlatform, content: {
                    ForEach(platformNames, id: \.self){ platform in
                        Text(platform).tag(platform)
                    }
                })
            }
            TextField("Search", text: bindSearch)
                .padding()
            Section(header: Text("Results"), footer: ActivityIndicator(shouldAnimate: self.$showAnimation)){
                List(gameResults.results, id: \.id){ game in
                    GameResultRow(title: game.name, id: game.id, platformArray: game.platforms)
                }
            }
        }
        .navigationBarTitle("Add Game")
        .onAppear(perform: {
            if platformNames.isEmpty{
                loadPlatformSelection()
            }
        })
    }
    
    //API note: use - character to subsitutue for space characters, as the API does not allow spaces in URLs (bad URL warnings will appear in the console if this is done)
    /**
     gameSearch: performs an API call to retrieve JSON data for games based on current search parameters
     parameters: searchTerm: string search term entered by the user, searchExact: boolean determining whether or not the search is exact, platformFilter: string used for filtering which platforms are being searched through
     */
    func gameSearch(_ searchTerm: String, _ searchExact: Bool, _ platformFilter: String) {
        //create the basic URL
        var urlString = "https://api.rawg.io/api/games?key=3c7897d6c00a4f0fae76833a5c8e743c&search=\(searchTerm)&search_exact=\(searchExact)"
        if platformDict[platformSelection] != nil{
            urlString.append("&platforms=\(platformDict[platformSelection]!)")
        }
        //detect if the URL is valid
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            showAnimation = true
            //data received
            if let data = data {
                //let str = String(decoding: data, as: UTF8.self)
                //print(str)
                //decode the data as a GameResults object
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(GameResults.self, from: data){
                    //set our gameResults object (object that contains visible results to the user)
                    gameResults = items
                    showAnimation = false
                    //data parsing was successful, so return
                    return
                }
                
            }
        }.resume()  //call our URLSession
    }
    
    /**
     loadPlatformSelection: function responsible for loading the current list of platforms the API supports, and displaying them to the user
     parameters: none
     */
    func loadPlatformSelection() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/platforms?key=3c7897d6c00a4f0fae76833a5c8e743c"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //let str = String(decoding: data, as: UTF8.self)
                //print(str)
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(PlatformSelection.self, from: data){
                    //for every platform found, store it's name as a key and id as a value in platformDict
                    //for every platform found, store it's name as an item in the platformNames array (array responsible for displaying the actual list of platforms to the user
                    for platform in items.results {
                        print(platform)
                        platformDict[platform.name] = platform.id
                        platformNames.append(platform.name)
                    }
                    //sort the platform names to they come across to the user the same every time...regardless of what order the API delivers them in
                    platformNames.sort()
                    print("\n")
                    //data parsing was successful, so return
                    return
                }
                
            }
        }.resume()  //call our URLSession
    }
}

//Preview struct
struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}

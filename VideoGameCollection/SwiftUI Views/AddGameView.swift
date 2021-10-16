//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

//import the following frameworks...
import SwiftUI
import CloudKit

/**
 View that contains the screen users will use to add new games to their collection
 */
struct AddGameView: View {
    @EnvironmentObject var gameObject: VideoGameCollection      //the object in the SwiftUI environment that contains the user's current game collection
    @State private var searchText = String()    //string sent into API calls with the search bar
    @State private var displayText = String()   //string to be displayed to the user when typing in the search bar
    @State private var gameResults: GameResults = GameResults()     //empty GameResults object that will later on store search results when used with the API
    @State private var showExact: Bool = false      //boolean value to toggle "exact search" filter on or off
    @State private var platformSelection = "No selection"     //string holding the user's selection of console/platform filter
    @State private var platformAPISelect = String()     //string holding the final string of the user's platform selection. This string must first be modified to have spaces removed from it with "-" character in it's place instead
    @State private var showAnimation = false    //boolean for determining when the activity indicator should be animating or not
    @State private var platformDict = [:]       //empty dictionary that will hold the names and ids of the platforms supported in the API at that time
    @State private var platformNames: [String] = []     //empty string array that will hold all of the names of the platforms supported by the API. Data is loaded into the array upon appearance of this view
    @State private var showScanner = false  //boolean that controls whether or not the sheet containing the view controller for the scanner will appear
    @State private var scanner: ScannerViewController? = ScannerViewController()    //instance of the view controller being used in this SwiftUI view
    @State private var postCameraSuccessAlert = false   //boolean that controls the alert that will appear if a game is found
    @State private var barcodeTitle = String()     //string containing the game title scanned by the barcode reader
    @State private var barcodeID = 0    //int that contains the game ID of the game found by the barcode scanner
    @State private var barcodePlatforms: [PlatformSearchResult] = []    //array of PlatformSearchResult objects that contain the platforms the scanned game supports
    @State private var metacriticSort = true    //boolean that triggers whether or not the results returned should be sorted by their Metacritic scores
    @State private var canLoad = true
    @State private var invalidBarcode = false
    
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
        
        let bindMetacritic = Binding<Bool>(
            //display the current value of metacriticSort when called
            get: {self.metacriticSort},
            //set the value of metacriticSort to the new value, and call the gameSearch function
            set: {
                self.metacriticSort = $0
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
                if platformSelection != "No selection"{
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
                }
                else{
                    platformAPISelect = String()
                }
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
        if canLoad{
            Form{
                Section(header: Text("Filters")){
                    Toggle("Exact Search", isOn: bindExact)
                    Picker("Platform", selection: bindPlatform, content: {
                        ForEach(platformNames, id: \.self){ platform in
                            Text(platform).tag(platform)
                        }
                    })
                    Toggle("Sort by Metacritic", isOn: bindMetacritic)
                }
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(4)
                    TextField("Search", text: bindSearch)
                }
                Section(header: Text("Results"), footer: ActivityIndicator(shouldAnimate: self.$showAnimation)){
                    List(gameResults.results, id: \.id){ game in
                        GameResultRow(title: game.name, id: game.id, platformArray: game.platforms)
                    }
                }
            }
            .navigationTitle("Add Game")
            .navigationBarItems(trailing: Button{
                if canLoad{
                    showScanner.toggle()
                }
            }
            label:{
                Image(systemName: "barcode.viewfinder")
            })
            .onAppear(perform: {
                checkDatabaseStatus()
                if canLoad{
                    if platformNames.isEmpty{
                        loadPlatformSelection()
                    }
                }
            })
            .sheet(isPresented: $showScanner, onDismiss: {
                do{
                    if scanner?.upcString == nil{
                        throw BarcodeError.noBarcodeScanned
                    }
                    barcodeLookup(upcCode: (scanner?.upcString)!)
                }
                catch{
                    print(error)
                }
            }){
                if !postCameraSuccessAlert{
                    ViewControllerWrapper(scanner: $scanner)
                        .onAppear{
                            postCameraSuccessAlert = false
                        }
                }
            }
            .alert(isPresented: $postCameraSuccessAlert){
                Alert(title: Text("Game Found"), message: Text("Would you like to add \(barcodeTitle) to your collection?"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                    //call the function that loads the scanned barcode's game information
                    loadBarcodeGameInfo()
                    while barcodePlatforms.count == 0{
                        //do nothing. Stall the code until it's finished loading
                    }
                    //add the new game to the array of game's the user already has
                    let newGame = Game()
                    newGame.gameId = barcodeID
                    newGame.recordID = CKRecord.ID(recordName: String(barcodeID))
                    newGame.title = barcodeTitle
                    newGame.dateAdded = Date()
                    gameObject.gameCollection.append(newGame)
                    //save the new object to the user's file
                    VideoGameCollection.saveiCloudGame(newGame: newGame)
                }), secondaryButton: Alert.Button.cancel())
            }
        }
        else{
            Text("Unable to display data. Either RAWG or your internet connection is offline. Try again later 😞.")
        }
    }
    
    //API note: use - character to subsitutue for space characters, as the API does not allow spaces in URLs (bad URL warnings will appear in the console if this is done)
    /**
     gameSearch: performs an API call to retrieve JSON data for games based on current search parameters
     */
    func gameSearch(_ searchTerm: String, _ searchExact: Bool, _ platformFilter: String){
        var metacriticSortURLString = String()
        var urlString = String()
        //if metacriticSort attach the necessary ordering query parameters to the url
        if metacriticSort{
            metacriticSortURLString = "&ordering=-metacritic"
        }
        //create the basic URL
        print("In game search")
        if !barcodeTitle.isEmpty{
            urlString = "https://api.rawg.io/api/games?key=\(rawgAPIKey)&search=\(searchTerm)&search_exact=\(searchExact)"
        }
        else{
            urlString = "https://api.rawg.io/api/games?key=\(rawgAPIKey)&search=\(searchTerm)&search_exact=\(searchExact)\(metacriticSortURLString)"
        }
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
            //start the loading indicator animation
            showAnimation = true
            //data received
            if let data = data {
                //decode the data as a GameResults object
                let decoder = JSONDecoder()
                print("Starting decoding")
                if let items = try? decoder.decode(GameResults.self, from: data){
                    print("Finished decoding and barcodeTitle is \(barcodeTitle)")
                    //set our gameResults object (object that contains visible results to the user)
                    gameResults = items
                    showAnimation = false   //disable the animation
                    //the barcode title is not empty and there are results returned, assign the first game returned as barcode information, and trigger the alert that a game was found
                    if !barcodeTitle.isEmpty && items.count != 0{
                        barcodeTitle = items.results[0].name
                        barcodeID = items.results[0].id
                        postCameraSuccessAlert.toggle()
                        print("Barcode success!")
                    }
                    //data parsing was successful, so return
                    return
                }
                
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Load the details of a game (only when used with a barcode scan) based on it's ID from the API, decode the data, and update this views properites accordingly with that data
     */
    func loadBarcodeGameInfo(){
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(barcodeID))?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //decode the data as a GameDetails objecct
                let decoder = JSONDecoder()
                if let details = try? decoder.decode(GameDetails.self, from: data){
                    print("Successfully decoded")
                    //data parsing was successful, so return
                    barcodePlatforms = details.platforms
                    return
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function responsible for loading the current list of platforms the API supports, and displaying them to the user
     parameters: none
     */
    func loadPlatformSelection() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/platforms?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
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
                    platformNames.insert("No selection", at: 0)
                    //data parsing was successful, so return
                    return
                }
                
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that takes a upc code from a barcode, and returns what product it is according to the Barcode Lookup API
     */
    func barcodeLookup(upcCode: String){
        barcodeTitle = String()
        //create the basic URL
        let urlString = "https://api.barcodelookup.com/v3/products?barcode=\(upcCode)&formatted=y&key=\(barcodeLookupAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let results = try? decoder.decode(BarcodeResults.self, from: data){
                    if results.products.count != 0{
                        print(results.products[0].title)
                        //convert the top result into an array
                        //insert a "-" char at every space to ensure it can be used with a URL
                        var charArray = Array(results.products[0].title)
                        var index = 0   //variable for holding the current iteration of the below for loop
                        //iterate through all the chars in the array, replacing every " " with "-" for valid API calls
                        for char in charArray{
                            if char == " "{
                                charArray[index] = "-"
                            }
                            index += 1
                        }
                        //set the barcode title to the top result's title
                        print("Go to game search...")
                        barcodeTitle = String(charArray)
                        gameSearch(barcodeTitle, false, platformAPISelect)
                    }
                    else{
                        //invalid barcode found, or barcode with no UPC code found
                        invalidBarcode.toggle()
                    }
                }
            }
        }.resume()  //call our URLSession
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
            } else  {
                print("Failed")
                canLoad = false
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

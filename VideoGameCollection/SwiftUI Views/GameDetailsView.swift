//
//  GameDetailsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/12/21.
//

import SwiftUI
import CloudKit

/**
 View that displays the details of a game, and lets the user add/remove a game from their collection
 */
struct GameDetailsView: View {
    var id: Int     //id of the game to be viewed
    @EnvironmentObject var gameObject: VideoGameCollection      //the object in the SwiftUI environment that contains the user's current game collection
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var name: String = String()      //the name of the game
    @State private var description: String = String()   //the description of the game
    @State private var releaseDate: String = String()   //the release date of the game in the form of a string
    @State private var imageURL = String()      //the url of the main background image
    @State private var rating = "Rating Pending"    //the ESRB rating of the game with a default value of "Rating Pending" if the game is not rated
    @State private var metacriticRating = 0     //the metacritic rating of the game with a default value of 0
    @State private var gameImage: UIImage = UIImage()   //the UIImage of the game's main background image
    @State private var fullyLoaded = false      //boolean value determining if the game's data is fully loaded or not
    @State private var showAnimation = true     //boolean value determining if the activity indicator animation should be shown or not
    @State private var partOfCollection = false  //boolean value determining if the current game being displayed is apart of the user's collection or not
    @State private var gameAlert = false        //boolean value determining if the alert showing that the user's collection was modified should be on or off
    @State private var screenCollection = GameScreenshot()  //instance of the object that will contain the screenshots for the game once the data is loaded
    @State private var screenshots: [String:UIImage] = [:]  //array of screenshots that will be displayed. The string key is the url of the screenshot, the UIImage is the image returned from the search with that URL
    @State private var gamePlatforms: [PlatformSearchResult] = []   //array of Platforms that the game supports
    @State private var fullScreenImage: UIImage = UIImage()
    @State private var showImageFullScreen = false
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var showTip = false
    @State private var storeLinks: [URL:UIImage] = [:]
    
    //main SwiftUI body
    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation; print("Being dragged") }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                    self.isDragging = false
                }
            }
        let pressGesture = LongPressGesture()
            .onChanged{ action in
                withAnimation{
                    print("Pressing...")
                    self.isDragging = true
                }
            }
            .onEnded { value in
                withAnimation {
                    print("Long press")
                    self.isDragging = true
                }
            }
        Group{
            if fullyLoaded{
                if showImageFullScreen{
                    if showTip{
                        Text("Tap the image to exit full screen 👇")
                    }
                    Image(uiImage: fullScreenImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(lastScaleValue)
                        .offset(offset)
                        .onTapGesture {
                            withAnimation{
                                showImageFullScreen = false
                            }
                        }
                        .gesture(MagnificationGesture()
                                    .onChanged{ value in
                                        withAnimation{
                                            showTip = false
                                        }
                                        self.lastScaleValue = value.magnitude
                                    }
                                    .onEnded{ value in
                                        withAnimation{
                                            showTip = true
                                            self.lastScaleValue = 1.0
                                        }
                                    }
                        )
                        .gesture(pressGesture.sequenced(before: dragGesture))
                }
                else{
                    ScrollView{
                        VStack{
                            Image(uiImage: gameImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Text(releaseDate)
                            if partOfCollection{
                                Button("Remove from Collection"){
                                    var index = 0
                                    for game in gameObject.gameCollection{
                                        if game.gameId == id{
                                            let oldGame = gameObject.gameCollection[index]
                                            gameObject.gameCollection.remove(at: index)
                                            VideoGameCollection.deleteiCloudGame(oldGame: oldGame)
                                            partOfCollection = false
                                            gameAlert = true
                                        }
                                        index += 1
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25))
                            }
                            else{
                                Button("Add to Collection"){
                                    let newGame = Game()
                                    newGame.gameId = id
                                    newGame.dateAdded = Date()
                                    newGame.title = name
                                    newGame.recordID = CKRecord.ID(recordName: String(id))
                                    gameObject.gameCollection.append(newGame)
                                    VideoGameCollection.saveiCloudGame(newGame: newGame)
                                    partOfCollection = true
                                    gameAlert = true
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25))
                            }
                            HStack{
                                if metacriticRating != 0{
                                    Image("metacritic")
                                        .resizable()
                                        .scaledToFit()
                                        .background(Color.black)
                                        .frame(width: 75, height: 75)
                                        .padding()
                                    Text(String(metacriticRating))
                                        .font(.title)
                                    Spacer()
                                }
                                Image(rating)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding()
                            }
                            Text(description)
                                .font(.subheadline)
                                .padding()
                            Text("Platforms")
                                .font(.title2)
                                .padding()
                            ForEach(gamePlatforms, id: \.self){ platform in
                                Text(platform.platform.name)
                                Spacer()
                            }
                            Text("Screenshots")
                                .font(.title2)
                                .padding()
                            Text("Tap images to see them full screen 👇")
                            ScrollView(.horizontal, showsIndicators: true){
                                HStack{
                                    ForEach(screenCollection.results, id: \.self){ game in
                                        if sizeClass == .regular{
                                            //set the width and height of the images to whatever width and height numbers for it where returned from the data
                                            Image(uiImage: screenshots[game.image]!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: CGFloat(game.width), height: CGFloat(game.height))
                                                .border(Color.blue, width: 5)
                                                .padding()
                                                .onTapGesture {
                                                    fullScreenImage = screenshots[game.image]!
                                                    showImageFullScreen = true
                                                    showTip = true
                                                }
                                        }
                                        else{
                                            //set the width and height of the images to whatever width and height numbers for it where returned from the data
                                            Image(uiImage: screenshots[game.image]!)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: CGFloat(315), height: CGFloat(250))
                                                .border(Color.blue, width: 2)
                                                .padding()
                                                .onTapGesture {
                                                    withAnimation{
                                                        fullScreenImage = screenshots[game.image]!
                                                        showImageFullScreen = true
                                                        showTip = true
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarTitle(name)
                }
            }
            //display the loading indicator if the data is not fully loaded yet
            else{
                VStack{
                    Text("Loading")
                    ActivityIndicator(shouldAnimate: self.$showAnimation)
                }
            }
        }
        .onAppear{
            //load all of the detials, status collection (whether or not it's in the collection already), and screenshots for the game
            loadGameDetails()
            loadGameStatus()
            loadGameScreenshots()
            loadStores()
            //update the UserDefault "lastViewedGame" key. This is intended to hold the last game the user viewed in the app
            UserDefaults.standard.setValue(id, forKey: "lastViewedGame")
        }
        .alert(isPresented: $gameAlert){
            Alert(title: Text("Success"), message: Text("Your change has been saved to your collection"), dismissButton: .default(Text("OK")))
        }
    }
    
    /**
     Load the details of a game based on it's ID from the API, decode the data, and update this views properites accordingly with that data
     */
    func loadGameDetails() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let details = try? decoder.decode(GameDetails.self, from: data){
                    print("Successfully decoded")
                    //data parsing was successful
                    //set each of the needed states with the data returned
                    name = details.name
                    let data = Data(details.description.utf8)
                    //filter out the HTML elements of the description string, and set its state accordingly
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        description = attributedString.string
                    }
                    releaseDate = details.released
                    rating = details.esrb_rating?.name ?? "Rating Pending"
                    metacriticRating = details.metacritic ?? 0
                    gamePlatforms = details.platforms
                    //get our main background image for the game using the URL provided in the data
                    let imageUrl = URL(string: details.background_image)
                    //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                    let imageData = try? Data(contentsOf: imageUrl!)
                    if let imageDataVerified = imageData {
                        let image = UIImage(data: imageDataVerified)
                        //Set the UIImage for the view accordingly
                        gameImage = image ?? UIImage()
                    }
                    //disable the activity indicator animation, and indicate that all data is fully loaded
                    fullyLoaded = true
                    showAnimation = false
                    return
                }
                else{
                    print("Decoding failed")
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that loads all of the game's screenshots into the view
     */
    func loadGameScreenshots() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))/screenshots?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let data = try? decoder.decode(GameScreenshot.self, from: data){
                    for game in data.results{
                        //get our main background image for the game using the URL provided in the data
                        let imageUrl = URL(string: game.image)
                        //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                        let imageData = try? Data(contentsOf: imageUrl!)
                        if let imageDataVerified = imageData {
                            let image = UIImage(data: imageDataVerified)
                            //Set the UIImage for the view accordingly
                            screenshots[game.image] = image!
                        }
                    }
                    //set our screenCollection state to equal whatever our data was
                    screenCollection = data
                    return
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that loads all of the game's possible retailers into the view
     */
    func loadStores() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))/stores?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                if let data = try? JSONDecoder().decode(GameDetailsStoreResults.self, from: data){
                    for store in data.results{
                        //assuming here that the API provided store ID will always be an integer
                        loadStoreInfo(storeID: Int(store.store_id)!, gameStoreURL: URL(string: store.url)!)
                    }
                    return
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that loads all of the game's possible retailers into the view
     */
    func loadStoreInfo(storeID: Int, gameStoreURL: URL) {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/stores/\(String(storeID))?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                if let data = try? JSONDecoder().decode(Store.self, from: data){
                    //get our main background image for the store using the URL provided in the data
                    let imageUrl = URL(string: data.image_background)
                    //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                    let imageData = try? Data(contentsOf: imageUrl!)
                    if let imageDataVerified = imageData {
                        let image = UIImage(data: imageDataVerified)
                        storeLinks[gameStoreURL] = image
                    }
                    return
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that returns true or false if a game is apart of the user's collection or not
     */
    func loadGameStatus(){
        //for each game in the collection, check if the current one matches the current game's id
        //if it's a match...set partOfCollection to true, false otherwise
        for game in gameObject.gameCollection{
            if game.gameId == id{
                partOfCollection = true
                break
            }
            else{
                partOfCollection = false
            }
        }
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(id: 30119)
    }
}

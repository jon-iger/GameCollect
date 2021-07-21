//
//  GameDetailsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/12/21.
//

import SwiftUI

/**
 View that displays the details of a game, and lets the user add/remove a game from their collection
 */
struct GameDetailsView: View {
    var id: Int     //id of the game to be viewed
    @EnvironmentObject var gameObject: VideoGameCollection      //the object in the SwiftUI environment that contains the user's current game collection
    @State var name: String = String()      //the name of the game
    @State var description: String = String()   //the description of the game
    @State var releaseDate: String = String()   //the release date of the game in the form of a string
    @State var imageURL = String()      //the url of the main background image
    @State var rating = "Rating Pending"    //the ESRB rating of the game with a default value of "Rating Pending" if the game is not rated
    @State var metacriticRating = 0
    @State var gameImage: UIImage = UIImage()   //the UIImage of the game's main background image
    @State var fullyLoaded = false      //boolean value determining if the game's data is fully loaded or not
    @State var showAnimation = true     //boolean value determining if the activity indicator animation should be shown or not
    @State var partOfCollection = true  //boolean value determining if the current game being displayed is apart of the user's collection or not
    @State var gameAlert = false        //boolean value determining if the alert showing that the user's collection was modified should be on or off
    @State var screenCollection = GameScreenshot()
    @State var screenshots: [String:UIImage] = [:]
    
    
    //main SwiftUI body
    var body: some View {
        Group{
            if id == 0{
                Text("Welcome!")
            }
            else{
                if fullyLoaded{
                    ScrollView{
                        VStack{
                            Image(uiImage: gameImage)
                                .resizable()
                                .scaledToFit()
                                .padding()
                            Text(releaseDate)
                            if partOfCollection{
                                Button("Remove from Collection"){
                                    if let i = gameObject.gameCollection.firstIndex(of: id){
                                        gameObject.gameCollection.remove(at: i)
                                        VideoGameCollection.saveToFile(basicObject: gameObject)
                                        partOfCollection = false
                                        gameAlert = true
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25))
                            }
                            else{
                                Button("Add to Collection"){
                                    gameObject.gameCollection.append(id)
                                    VideoGameCollection.saveToFile(basicObject: gameObject)
                                    partOfCollection = true
                                    gameAlert = true
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25))
                            }
                            HStack{
                                Image("metacritic")
                                    .resizable()
                                    .scaledToFit()
                                    .background(Color.black)
                                    .frame(width: 75, height: 75)
                                    .padding()
                                Text(String(metacriticRating))
                                    .font(.title)
                                Spacer()
                                Image(rating)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .padding()
                            }
                            Text(description)
                                .font(.subheadline)
                                .padding()
                            Text("Screenshots")
                                .font(.title2)
                                .padding()
                            ScrollView(.horizontal, showsIndicators: true){
                                HStack{
                                    ForEach(screenCollection.results, id: \.self){ game in
                                        Image(uiImage: screenshots[game.image]!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: CGFloat(game.width), height: CGFloat(game.height))
                                            .border(Color.blue, width: 5)
                                            .padding()
                                    }
                                }
                            }
                        }
                        .navigationBarTitle(name)
                    }
                }
                else{
                    VStack{
                        Text("Loading")
                        ActivityIndicator(shouldAnimate: self.$showAnimation)
                    }
                }
            }
        }
        .onAppear{
            loadGameDetails()
            loadGameStatus()
            loadGameScreenshots()
            //update the UserDefault "lastViewedGame" key. This is intended to hold the last game the user viewed in the app.
            UserDefaults.standard.setValue(id, forKey: "lastViewedGame")
        }
        .alert(isPresented: $gameAlert){
            Alert(title: Text("Success"), message: Text("Your change has been saved to your collection"), dismissButton: .default(Text("OK")))
        }
    }
    
    /**
     Load the details of a game based on it's ID from the API, decode the data, and update this views properites accordingly with that data
     parameters: none
     */
    func loadGameDetails() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))?key=3c7897d6c00a4f0fae76833a5c8e743c"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
//                let str = String(decoding: data, as: UTF8.self)
//                print(str)
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let details = try? decoder.decode(GameDetails.self, from: data){
                    print("Successfully decoded")
                    //data parsing was successful
                    //set each of the needed States with the data returned
                    name = details.name
                    let data = Data(details.description.utf8)
                    //filter out the HTML elements of the description string, and set its state accordingly
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        description = attributedString.string
                    }
                    releaseDate = details.released
                    rating = details.esrb_rating?.name ?? "Rating Pending"
                    metacriticRating = details.metacritic
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
            }
        }.resume()  //call our URLSession
    }
    
    func loadGameScreenshots() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))/screenshots?key=3c7897d6c00a4f0fae76833a5c8e743c"
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
                    screenCollection = data
                    return
                }
            }
        }.resume()  //call our URLSession
    }
    
    /**
     Function that returns true or false if a game is apart of the user's collection or not
     */
    func loadGameStatus(){
        if gameObject.gameCollection.contains(id){
            partOfCollection = true
        }
        else{
            partOfCollection = false
        }
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(id: 30119)
    }
}

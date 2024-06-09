//
//  GameDetailsViewModel.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/9/24.
//

import Foundation
import UIKit

extension GameDetailsView {
    @Observable
    class ViewModel {
        // MARK: Variables
        var id: Int
        var name: String = String()      //the name of the game
        var description: String = String()   //the description of the game
        var releaseDate: String = String()   //the release date of the game in the form of a string
        var imageURL = String()      //the url of the main background image
        var rating = "Rating Pending"    //the ESRB rating of the game with a default value of "Rating Pending" if the game is not rated
        var metacriticRating = 0     //the metacritic rating of the game with a default value of 0
        var gameImage: UIImage = UIImage()   //the UIImage of the game's main background image
        var fullyLoaded = false      //boolean value determining if the game's data is fully loaded or not
        var showAnimation = true     //boolean value determining if the activity indicator animation should be shown or not
        var partOfCollection = false  //boolean value determining if the current game being displayed is apart of the user's collection or not
        var screenCollection = GameScreenshot()  //instance of the object that will contain the screenshots for the game once the data is loaded
        var screenshots: [String:UIImage] = [:]  //array of screenshots that will be displayed. The string key is the url of the screenshot, the UIImage is the image returned from the search with that URL
        var gamePlatforms: [PlatformSearchResult] = []   //array of Platforms that the game supports
        var fullScreenImage: UIImage = UIImage()
        var showImageFullScreen = false
        var storeLinks: [URL:UIImage] = [:]
        
        // MARK: Initializer
        init(gameId: Int) {
            id = gameId
        }
        
        // MARK: Functions
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
                        self.name = details.name
                        let data = Data(details.description.utf8)
                        //filter out the HTML elements of the description string, and set its state accordingly
                        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                            self.description = attributedString.string
                        }
                        self.releaseDate = details.released
                        self.rating = details.esrb_rating?.name ?? "Rating Pending"
                        self.metacriticRating = details.metacritic ?? 0
                        self.gamePlatforms = details.platforms
                        //get our main background image for the game using the URL provided in the data
                        let imageUrl = URL(string: details.background_image)
                        //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                        let imageData = try? Data(contentsOf: imageUrl!)
                        if let imageDataVerified = imageData {
                            let image = UIImage(data: imageDataVerified)
                            //Set the UIImage for the view accordingly
                            self.gameImage = image ?? UIImage()
                        }
                        //disable the activity indicator animation, and indicate that all data is fully loaded
                        self.fullyLoaded = true
                        self.showAnimation = false
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
                                self.screenshots[game.image] = image!
                            }
                        }
                        //set our screenCollection state to equal whatever our data was
                        self.screenCollection = data
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
            print("Starting decoding...in load stores")
            //start our URLSession to get data
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    if let data = try? JSONDecoder().decode(GameDetailsStoreResults.self, from: data){
                        for store in data.results{
                            //assuming here that the API provided store ID will always be an integer
                            self.loadStoreInfo(storeID: store.store_id, gameStoreURL: URL(string: store.url)!)
                        }
                        print("Decoding complete")
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
                            self.storeLinks[gameStoreURL] = image
                        }
                        print("Decoded a store")
                        return
                    }
                }
            }.resume()  //call our URLSession
        }
        
        /**
         Function that returns true or false if a game is apart of the user's collection or not
         */
        func loadGameStatus(games: [Game]){
            //for each game in the collection, check if the current one matches the current game's id
            //if it's a match...set partOfCollection to true, false otherwise
            for game in games{
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
}

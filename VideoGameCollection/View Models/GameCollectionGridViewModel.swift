//
//  GameCollectionGridViewModel.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/9/24.
//

import Foundation
import UIKit

extension GameCollectionGrid {
    @Observable
    class ViewModel {
        // MARK: Variables
        var name = String()
        var gameImage = UIImage()
        var fullyLoaded = false
        
        // MARK: Functions
        /**
         Load the details of a game based on it's ID from the API, decode the data, and update this views properites accordingly with that data
         parameters: none
         */
        func loadGameInfo(gameId: Int) {
            //create the URL
            let urlString = "https://api.rawg.io/api/games/\(String(gameId))?key=\(APIAccess.getAPIKey(environmentKey: ServiceAPI.rawg.rawValue))"
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            print("Starting decoding...")
            //start URLSession to get data
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest = 30.0
            session.configuration.timeoutIntervalForResource = 60.0
            session.dataTask(with: url) { data, response, error in
                if let data = data {
    //                let str = String(decoding: data, as: UTF8.self)
    //                print(str)
                    //decode the data as a PlatformSelection objecct
                    let decoder = JSONDecoder()
                    if let details = try? decoder.decode(GameDetails.self, from: data){
                        print("Successfully decoded")
                        //data parsing was successful, so return
                        self.name = details.name
                        let imageUrl = URL(string: details.background_image)
                        //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                        let imageData = try? Data(contentsOf: imageUrl!)
                        if let imageDataVerified = imageData {
                            let image = UIImage(data: imageDataVerified)
                            self.gameImage = image ?? UIImage()
                        }
                        self.fullyLoaded = true
                        return
                    }
                }
            }.resume()  //call URLSession
        }
    }
}

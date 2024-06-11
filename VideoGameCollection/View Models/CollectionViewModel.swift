//
//  CollectionViewModel.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/9/24.
//

import Foundation
import SwiftUI

extension CollectionView {
    @Observable
    class ViewModel {
        // MARK: Variables
        var searchText = String()    //string used for holding the user's current search text
        var activeSearch = false
        var searchResults: [Int] = []
        var gridView = false
        var platformDict: [Platform:[Int]] = [:]
        var platformFilter = false
        var canLoad = true
        var shouldAnimate = true
        
        init(){}
        
        // MARK: Functions
        /**
         Attempts to load sample data from the RAWG API. If this fails, the screen is stopped from rendering. Otherwise it can proceed
         parameters: none
         */
        func checkDatabaseStatus(){
            //create the basic URL
            let urlString = "https://api.rawg.io/api/games?key=\(APIAccess.getAPIKey(environmentKey: ServiceAPI.rawg.rawValue))&search="
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
                    self.canLoad = true
                    self.shouldAnimate = false
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
            urlRequest.addValue(APIAccess.getAPIKey(environmentKey: ServiceAPI.bingSearch.rawValue), forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
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
        
        func setBindSearch(string: String, games: [Game]) {
            searchResults = []
            activeSearch = true
            print("Setting")
            self.searchText = string
            for game in games{
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
    }
}

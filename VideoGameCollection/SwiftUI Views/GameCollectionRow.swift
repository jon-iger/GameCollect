//
//  GameCollectionRow.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/19/21.
//

import SwiftUI

struct GameCollectionRow: View {
    var id: Int
    @State private var name = String()
    @State private var releaseYear = String()
    @State private var gameImage = UIImage()
    @State private var fullyLoaded = false
    @State private var showAnimation = true
    var body: some View {
        NavigationLink(destination: GameDetailsView(id: self.id)){
            HStack{
                if fullyLoaded{
                    Image(uiImage: gameImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                    Text(name)
                }
                else{
                    Text("Loading")
                    ActivityIndicator(shouldAnimate: self.$showAnimation)
                }
            }
        }
        .onAppear{
            loadGameInfo()
        }
    }
    /**
     Load the details of a game based on it's ID from the API, decode the data, and update this views properites accordingly with that data
     parameters: none
     */
    func loadGameInfo() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))?key=\(rawgAPIKey)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 30.0
        session.configuration.timeoutIntervalForResource = 60.0
        session.dataTask(with: url) { data, response, error in
            if let data = data {
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let details = try? decoder.decode(GameDetails.self, from: data){
                    print("Successfully decoded")
                    //data parsing was successful, so return
                    name = details.name
                    let imageUrl = URL(string: details.background_image)
                    //force unwrapping is used here...assuming that the API will always provide an image url that is valid
                    let imageData = try? Data(contentsOf: imageUrl!)
                    if let imageDataVerified = imageData {
                        let image = UIImage(data: imageDataVerified)
                        gameImage = image ?? UIImage()
                    }
                    fullyLoaded = true
                    showAnimation = false
                    return
                }
            }
        }.resume()  //call our URLSession
    }
}

struct GameCollectionRow_Previews: PreviewProvider {
    static var previews: some View {
        GameCollectionRow(id: 0)
    }
}

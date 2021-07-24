//
//  GameCollectionRow.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/19/21.
//

import SwiftUI

struct GameCollectionRow: View {
    var id: Int
    @State var name = String()
    @State var releaseYear = String()
    @State var gameImage = UIImage()
    @State var fullyLoaded = false
    @State var showAnimation = true
    var body: some View {
        NavigationLink(destination: GameDetailsView(id: self.id)){
            HStack{
                if fullyLoaded{
                    Image(uiImage: gameImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                    Text(name)
                    Text(releaseYear)
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
        let urlString = "https://api.rawg.io/api/games/\(String(id))?key=\(apiKey)"
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
                    //data parsing was successful, so return
                    name = details.name
                    let tempString = Array(details.released)
                    var charArray: [Character] = ["1", "2", "3", "4"]
                    charArray[0] = tempString[0]
                    charArray[1] = tempString[1]
                    charArray[2] = tempString[2]
                    charArray[3] = tempString[3]
                    releaseYear = String(charArray)
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

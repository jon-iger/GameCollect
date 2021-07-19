//
//  GameDetailsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/12/21.
//

import SwiftUI

struct GameDetailsView: View {
    var id: Int
    @EnvironmentObject var gameObject: VideoGameCollection
    @State var name: String = String()
    @State var description: String = String()
    @State var releaseDate: String = String()
    @State var imageURL = String()
    @State var rating = "Rating Pending"
    @State var gameImage: UIImage = UIImage()
    @State var fullyLoaded = false
    @State var showAnimation = true
    @State var partOfCollection = true
    var body: some View {
        Group{
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
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 25))
                        }
                        Image(rating)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding()
                        Text(description)
                            .font(.subheadline)
                            .padding()
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
        .onAppear{
            loadGameDetails()
            loadGameStatus()
        }
    }
    
    /**
     loadGameDetails: load the details of a game based on it's ID from the API, decode the data, and update this views properites accordingly with that data
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
                    //data parsing was successful, so return
                    name = details.name
                    let data = Data(details.description.utf8)
                    if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                        description = attributedString.string
                    }
                    //description = details.description
                    releaseDate = details.released
                    rating = details.esrb_rating?.name ?? "Rating Pending"
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

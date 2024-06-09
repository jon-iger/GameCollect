//
//  GameDetailsView.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/12/21.
//

import SwiftUI
import CloudKit

/**
 View that displays the details of a game, and lets the user add/remove a game from their collection
 */
struct GameDetailsView: View {
    var id: Int     //id of the game to be viewed
    @EnvironmentObject var cloudContainer: CloudContainer      //the object in the SwiftUI environment that contains the user's current game collection
    @Environment(\.horizontalSizeClass) var sizeClass
    @State var viewModel: ViewModel
    
    init(gameId: Int? = nil) {
        if let newId = gameId {
            id = newId
        } else {
            id = 0
        }
        viewModel = ViewModel(gameId: id)
    }
    
    //main SwiftUI body
    var body: some View {
        if viewModel.fullyLoaded{
            ScrollView{
                VStack{
                    Image(uiImage: viewModel.gameImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    Text(viewModel.releaseDate)
                    CollectionButton(partOfCollection: viewModel.partOfCollection, id: self.id, name: viewModel.name)
                    HStack{
                        if viewModel.metacriticRating != 0{
                            Image("metacritic")
                                .resizable()
                                .scaledToFit()
                                .background(Color.black)
                                .frame(width: 75, height: 75)
                                .padding()
                            Text(String(viewModel.metacriticRating))
                                .font(.title)
                            Spacer()
                        }
                        Image(viewModel.rating)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding()
                    }
                    Text(viewModel.description)
                        .font(.subheadline)
                        .padding()
                    Text("Platforms")
                        .font(.title2)
                        .padding()
                    ForEach(viewModel.gamePlatforms, id: \.self){ platform in
                        Text(platform.platform.name)
                        Spacer()
                    }
                    ForEach(Array(viewModel.storeLinks.keys), id: \.self){ storeLink in
                        Link(destination: storeLink){
                            Image(uiImage: viewModel.storeLinks[storeLink]!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 75)
                                .padding()
                        }
                    }
                    Text("Screenshots")
                        .font(.title2)
                        .padding()
                    ImageGallery(screenCollection: viewModel.screenCollection, screenshots: viewModel.screenshots)
                }
            }
            .navigationTitle(viewModel.name)
        }
        //display the loading indicator if the data is not fully loaded yet
        else{
            VStack{
                Text("Loading")
                ActivityIndicator(shouldAnimate: $viewModel.showAnimation)
            }
            .onAppear{
                handleOnAppear()
            }
        }
    }
    func handleOnAppear() {
        //load all of the detials, status collection (whether or not it's in the collection already), and screenshots for the game
        viewModel.loadGameDetails()
        viewModel.loadGameStatus(games: cloudContainer.gameCollection)
        viewModel.loadGameScreenshots()
        viewModel.loadStores()
        //update the UserDefault "lastViewedGame" key. This is intended to hold the last game the user viewed in the app
        UserDefaults.standard.setValue(id, forKey: "lastViewedGame")
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(gameId: 30119)
    }
}

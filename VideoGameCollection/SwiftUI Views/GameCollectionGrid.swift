//
//  GameCollectionGrid.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/25/21.
//

import SwiftUI

/**
 View for displaying game collection should the user choose a grid display type
 */
struct GameCollectionGrid: View {
    // MARK: Variables
    @State var viewModel = ViewModel()
    var id: Int
    
    // MARK: SwiftUI Body
    var body: some View {
        NavigationLink(destination: GameDetailsView(gameId: self.id)){
            VStack{
                if viewModel.fullyLoaded{
                    VStack{
                        Image(uiImage: viewModel.gameImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                        Text(viewModel.name)
                    }
                    .padding(5)
                    
                }
                else{
                    Text("Loading")
                    ActivityIndicator(shouldAnimate: $viewModel.fullyLoaded.inverted)
                }
            }
        }
        .onAppear{
            viewModel.loadGameInfo(gameId: id)
        }
    }
}

// MARK: Content Preview
struct GameCollectionGrid_Previews: PreviewProvider {
    static var previews: some View {
        GameCollectionGrid(id: 0)
    }
}

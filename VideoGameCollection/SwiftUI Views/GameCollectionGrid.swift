//
//  GameCollectionGrid.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/25/21.
//

import SwiftUI

struct GameCollectionGrid: View {
    @State var viewModel = ViewModel()
    var id: Int
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

struct GameCollectionGrid_Previews: PreviewProvider {
    static var previews: some View {
        GameCollectionGrid(id: 0)
    }
}

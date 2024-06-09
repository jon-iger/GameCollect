//
//  GameCollectionRow.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/19/21.
//

import SwiftUI

struct GameCollectionRow: View {
    var id: Int
    @State private var viewModel = ViewModel()
    var body: some View {
        NavigationLink(destination: GameDetailsView(id: self.id)){
            HStack{
                if viewModel.fullyLoaded{
                    Image(uiImage: viewModel.gameImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                    Text(viewModel.name)
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

struct GameCollectionRow_Previews: PreviewProvider {
    static var previews: some View {
        GameCollectionRow(id: 0)
    }
}

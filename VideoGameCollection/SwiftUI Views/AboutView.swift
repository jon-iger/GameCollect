//
//  AboutView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/28/21.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack{
            Text("All data presented in this app is provided by the RAWG.org API. All images, titles, ratings, and game information are property of it's respective owners and not the Game Collect app.")
                .padding()
            Text("Game Collect is created by Jonathon Lannon with the intent that this app be distributed exclusively on Apple platforms. All rights reserved. Copyright 2021.")
                .padding()
        }
        .navigationBarTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

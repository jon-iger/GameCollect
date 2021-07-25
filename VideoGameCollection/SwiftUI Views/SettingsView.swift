//
//  SettingsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/24/21.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameObject: VideoGameCollection
    @State var showDeleteAlert = false
    var body: some View {
        VStack{
            Button("Delete All Data"){
                showDeleteAlert.toggle()
            }
            .padding()
            .border(Color.red, width: 3)
            Text("About")
                .font(.largeTitle)
            Text("All data presented in this app is provided by the RAWG.org API. All images, titles, ratings, and game information are property of it's respective owners and not the Game Collect app.")
                .padding()
            Text("Game Collect is created by Jonathon Lannon with the intent that this app be distributed exclusively on Apple platforms. All rights reserved. Copyright 2021.")
                .padding()
        }
        .alert(isPresented: $showDeleteAlert){
            Alert(title: Text("Delete data?"), message: Text("All data will be lost"), primaryButton: Alert.Button.destructive(Text("Delete")){
                gameObject.gameCollection = []
                VideoGameCollection.saveToFile(basicObject: gameObject)
            }, secondaryButton: Alert.Button.cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

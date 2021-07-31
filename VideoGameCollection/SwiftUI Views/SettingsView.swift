//
//  SettingsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/24/21.
//

import SwiftUI

/**
 View that displays the settings for the app, and provides navigation links for other parts such as About and Help
 */
struct SettingsView: View {
    @EnvironmentObject var gameObject: VideoGameCollection  //object containing the list of games currently in the user's collection
    @State var showDeleteAlert = false  //binding boolean value that triggers the on screen alert if tapped by the user to delete their data
    
    //main SwiftUI body
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Section(header: Text("Game Collect Information")){
                        NavigationLink(destination: MainHelpView()){
                            Image(systemName: "questionmark")
                            Text("Help")
                        }
                        NavigationLink(destination: AboutView()){
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                    }
                    Section(header: Text("Settings")){
                        Button{
                            showDeleteAlert.toggle()
                        }
                        label:{
                            HStack{
                                Image(systemName: "trash")
                                Text("Delete Data")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
            MainHelpView()
        }
        .alert(isPresented: $showDeleteAlert){
            Alert(title: Text("Delete data?"), message: Text("All data will be lost"), primaryButton: Alert.Button.destructive(Text("Delete")){
                //empty the array of games, and save the empty array to the save file
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

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

//
//  SettingsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/24/21.
//

import SwiftUI
import CloudKit

/**
 View that displays the settings for the app, and provides navigation links for other parts such as About and Help
 */
struct SettingsView: View {
    @EnvironmentObject var gameObject: VideoGameCollection  //object containing the list of games currently in the user's collection
    @State private var showDeleteAlert = false  //binding boolean value that triggers the on screen alert if tapped by the user to delete their data
    @State private var testID: CKRecord.ID = CKRecord.ID()
    
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
                        Link(destination: URL(string: "https://app.termly.io/document/privacy-policy/13f819ed-e94e-42fb-ba9a-ccdb64827a1a")!, label: {
                            HStack{
                                Image(systemName: "hand.raised")
                                Text("Privacy Policy")
                            }
                        })
                        Link(destination: URL(string: "https://app.termly.io/document/terms-of-use-for-ios-app/f8a6516e-0854-4737-8c19-c6db8487a022")!, label: {
                            HStack{
                                Image(systemName: "person")
                                Text("Terms of Use")
                            }
                        })
                        Link(destination: URL(string: "https://www.gamecollect.org")!, label: {
                            HStack{
                                Image(systemName: "network")
                                Text("Visit Our Website")
                            }
                        })
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
            .navigationTitle("Settings")
            MainHelpView()
        }
        .alert(isPresented: $showDeleteAlert){
            Alert(title: Text("Delete data?"), message: Text("All data will be lost"), primaryButton: Alert.Button.destructive(Text("Delete")){
                //empty the array of games, and save the empty array to the save file
                var oldRecordIDs: [CKRecord.ID] = []
                for game in gameObject.gameCollection{
                    oldRecordIDs.append(game.recordID)
                }
                gameObject.gameCollection = []
                VideoGameCollection.bulkDeleteiCloudGames(oldRecords: oldRecordIDs)
            }, secondaryButton: Alert.Button.cancel())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

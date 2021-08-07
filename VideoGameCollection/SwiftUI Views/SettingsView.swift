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
    @State var showDeleteAlert = false  //binding boolean value that triggers the on screen alert if tapped by the user to delete their data
    @State var testArray: [Game2] = []
    @State var testID: CKRecord.ID = CKRecord.ID()
    
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
                    Button("CloudKit Testing Add"){
                        let gameRecord = CKRecord(recordType: "Game")
                        gameRecord["title"] = "GameTesting1" as CKRecordValue
                        gameRecord["dateAdded"] = Date() as CKRecordValue
                        gameRecord["id"] = 0 as CKRecordValue
                        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").publicCloudDatabase.save(gameRecord) { record, error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print("Success in the Cloud!")
                                }
                            }
                        }
                    }
                    Button("CloudKit Testing Load"){
                        let pred = NSPredicate(value: true)
                        let query = CKQuery(recordType: "Game", predicate: pred)
                        
                        let operation = CKQueryOperation(query: query)
                        operation.desiredKeys = ["title", "id", "dateAdded"]
                        operation.resultsLimit = 50
                        testArray = []
                        operation.recordFetchedBlock = { record in
                            let game = Game2()
                            game.id = record["id"]
                            game.title = record["title"]
                            game.dateAdded = record["dateAdded"]
                            testID = record.recordID
                            testArray.append(game)
                        }
                        operation.queryCompletionBlock = {(cursor, error) in
                            DispatchQueue.main.async {
                                if error == nil {
                                    print("Cloud load success!")
                                } else {
                                    print("Cloud load failed!")
                                }
                            }
                        }
                        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").publicCloudDatabase.add(operation)
                    }
                    Button("Read out CloudKit"){
                        for game in testArray{
                            print(game.title!)
                        }
                    }
                    Button("Delete out of CloudKit"){
                        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").publicCloudDatabase.delete(withRecordID: testID){(recordID, error) in
                            if error == nil{
                                print("Cloud delete success!")
                            }
                            else{
                                print(error?.localizedDescription as Any)
                            }
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

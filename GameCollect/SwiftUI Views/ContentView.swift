//
//  ContentView.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/7/21.
//

import SwiftUI
import CoreData

/**
 View to display the user's current games in their collection
 */
struct ContentView: View {
    @State private var iCloudStatusAlert = false
    @State private var iCloudStatusMessage = String()
    //SwiftUI body
    var body: some View {
        TabView{
            CollectionView()
            .tabItem{
                Image(systemName: "house")
                Text("Home")
            }
            NavigationView{
                AddGameView()
                GameDetailsView(id: UserDefaults.standard.integer(forKey: "lastViewedGame"))
            }
            .tabItem{
                Image(systemName: "plus")
                Text("Add")
            }
            SettingsView()
                .tabItem{
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .alert(isPresented: $iCloudStatusAlert){
            Alert(title: Text("iCloud Error"), message: Text(iCloudStatusMessage), primaryButton: Alert.Button.default(Text("OK")){
                print("User ignored iCloud Warning")
            }, secondaryButton: Alert.Button.default(Text("Go to Settings")){
                let application = UIApplication.shared
                if let url = URL(string: UIApplication.openSettingsURLString), application.canOpenURL(url)    {
                    application.open(url, options: [:], completionHandler: nil)
                }
            })
        }
        .onAppear{
            container.accountStatus(completionHandler: {status, error in
                print("iCloud account status code \(status.rawValue)")
                let accountStatusCode = status.rawValue
                switch accountStatusCode {
                    case 0:
                        iCloudStatusMessage = "Could not determine status. Completion handler executed properly, but Apple could not determine the status."
                        print("iCloud Account Status = 0")
                    case 1:
                        print("iCloud Account Status = 1")
                    case 2:
                        iCloudStatusMessage = "System restrictions have denied the user the ability to access iCloud on this device. Go to Settings to resolve the issue."
                        print("iCloud Account Status = 2")
                    case 3:
                        iCloudStatusMessage = "No iCloud account is signed into on this device. Go to Settings to resolve this issue."
                        print("iCloud Account Status = 3")
                    case 4:
                        iCloudStatusMessage = "iCloud is not available at this time. Could not load data. Try again later."
                        print("iCloud Account Status = 4")
                    default:
                        iCloudStatusMessage = "Unknown error. Contact the developer for more support."
                        print("iCloud Account Status could not be determined")
                }
                iCloudStatus = accountStatusCode
                if accountStatusCode != 1{
                    iCloudStatusAlert.toggle()
                }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

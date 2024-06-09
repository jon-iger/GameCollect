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
    @State var viewModel: ContentViewModel
    private var iCloudStatusMessage = String()
    
    //SwiftUI body
    init() {
        viewModel = ContentViewModel()
    }
    
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
        .alert(isPresented: $viewModel.iCloudStatusAlert){
            Alert(title: Text("iCloud Error"), message: Text($viewModel.errorMessage.wrappedValue), primaryButton: Alert.Button.default(Text("OK")){
                print("User ignored iCloud Warning")
            }, secondaryButton: Alert.Button.default(Text("Go to Settings")){
                openPhoneSettings()
            })
        }
        .onAppear{
            setupViewOnAppear()
        }
    }
    
    func setupViewOnAppear() {
        viewModel.checkCloudStatus()
    }
    
    func openPhoneSettings () {
        let application = UIApplication.shared
        if let url = URL(string: UIApplication.openSettingsURLString), application.canOpenURL(url)    {
            application.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

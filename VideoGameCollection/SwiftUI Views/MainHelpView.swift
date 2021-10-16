//
//  MainHelpView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/28/21.
//

import SwiftUI

/**
 View that will provide users basic FAQ and help information for the app
 */
struct MainHelpView: View {
    var body: some View {
        VStack{
            List{
                Section(header: Text("What is Game Collect?")){
                    Text("Game Collect is a soon to be launched iOS app that allows gamers to track what games they have in their game collections. Search for your games by their title, or scan their barcode using the barcode scanner.")
                        .padding()
                }
                Section(header: Text("What can you do once you find a game?")){
                    Text("With Game Collect, you can either add the game to your collection, or choose to remove it should you choose to. You can also read more about games you find. Read through the game’s description, ESRB rating, platforms the game is available on, or view screenshots for the game.")
                        .padding()
                }
                Section(header: Text("What devices will this app support?")){
                    Text("This app will support any Apple iOS or iPadOS device running version 14.0 or later. The app is designed to be accommodating to all sorts of devices. Whether you choose to run this app on an iPhone 7 or an iPad Pro, your game collection will still look fabulous!")
                        .padding()
                }
                Section(header: Text("Where can I get this app?")){
                    Text("For right now, the app is not available for distribution due to it still being in early development. However, there are plans for a series of beta testing periods, where members of the public can use the app and participate in providing feedback. Upon launch, which is TBA, it will launch on the Apple App Store for $0.99 in the United States.")
                        .padding()
                }
                Section(header: Text("What kinds of technologies were used in building this app?")){
                    Text("The app utilizes third party API’s provided by RAWG.org and Barcode Lookup. The core app is built using Apple’s Xcode IDE, and utilize’s the Swift language and SwiftUI framework to make this possible. SwiftUI’s ability to provide a clean, simple user interface for user’s, combined with its ability to deliver fast performance help make Game Collect a powerful app.")
                        .padding()
                }
                Section(header: Text("Who built this app?")){
                    Text("The main creator of this app is Jonathon Lannon. A recent Grove City College graduate with a Bachelor’s of Science in Computer Information Systems, Jonathon saw that his passion for iOS mobile development and love of collecting games could combine together to create this app.")
                        .padding()
                }
                Section(header: Text("How can I report feedback to the development team?")){
                    Text("Have a question about how the app works? Have you experienced a bug or crash within the app? Or maybe you just want to provide feedback from your experience?? You can email us at game_collect@outlook.com, and we will reach out to you about your concerns.")
                        .padding()
                }
            }
        }
        .navigationTitle("Help")
    }
}

struct MainHelpView_Previews: PreviewProvider {
    static var previews: some View {
        MainHelpView()
    }
}

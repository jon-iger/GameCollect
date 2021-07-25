//
//  SettingsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/24/21.
//

import SwiftUI

struct SettingsView: View {
    @State var showDeleteAlert = false
    var body: some View {
        VStack{
            Text("Settings")
                .font(.largeTitle)
            Spacer()
            Button("Delete All Data"){
                showDeleteAlert.toggle()
            }
        }
        .alert(isPresented: $showDeleteAlert){
            Alert(title: Text("Delete data?"), message: Text("All data will be lost"), dismissButton: Alert.Button.destructive(Text("OK")))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

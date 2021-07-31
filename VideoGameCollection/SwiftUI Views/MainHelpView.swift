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
            Text("Help")
        }
        .navigationBarTitle("Help")
    }
}

struct MainHelpView_Previews: PreviewProvider {
    static var previews: some View {
        MainHelpView()
    }
}

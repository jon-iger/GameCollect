//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

import SwiftUI

struct AddGameView: View {
    @State var searchText = String()
    var body: some View {
        VStack{
            TextField("Search", text: $searchText)
                .padding()
                .border(Color.black)
            Spacer()
        }
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}

//
//  GameResultRow.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/11/21.
//

import SwiftUI

struct GameResultRow: View {
    let title: String
    let platform: String
    var body: some View {
        VStack{
            Text(title)
            Text(platform)
                .font(.subheadline)
        }
    }
}

struct GameResultRow_Previews: PreviewProvider {
    static var previews: some View {
        GameResultRow(title: "Super Mario Odyssey", platform: "Nintendo")
    }
}

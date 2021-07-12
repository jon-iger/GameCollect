//
//  GameResultRow.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/11/21.
//

import SwiftUI

struct GameResultRow: View {
    let title: String
    let platformArray: [PlatformSearchResult]
    var body: some View {
        VStack{
            VStack{
                Text(title)
                    .multilineTextAlignment(.center)
            }
            .padding()
            HStack{
                ForEach(platformArray, id: \.self){ platform in
                    Text(platform.platform.name)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
    }
}

struct GameResultRow_Previews: PreviewProvider {
    static var previews: some View {
        GameResultRow(title: "Sonic the Hedgehog", platformArray: [])
    }
}

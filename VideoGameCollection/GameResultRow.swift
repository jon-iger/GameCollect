//
//  GameResultRow.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/11/21.
//

//import the following frameworks...
import SwiftUI

struct GameResultRow: View {
    let title: String   //name of the game to be displayed
    let platformArray: [PlatformSearchResult]   //array of platform search results
    
    //main SwiftUI body
    var body: some View {
        VStack{
            VStack{
                Text(title)
                    .multilineTextAlignment(.center)
            }
            .padding()
            HStack{
                //for each platform, display it's name
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

//preview struct
struct GameResultRow_Previews: PreviewProvider {
    static var previews: some View {
        GameResultRow(title: "Sonic the Hedgehog", platformArray: [])
    }
}

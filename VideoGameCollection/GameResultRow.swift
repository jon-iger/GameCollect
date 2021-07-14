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
    var stringPlatforms: String {
        var tempString = String()
        for platform in platformArray{
            tempString.append(platform.platform.name)
            tempString.append(", ")
        }
        return tempString
    }
    
    //main SwiftUI body
    var body: some View {
        VStack{
            Text(title)
                .padding()
            Text(stringPlatforms)
                .font(.caption)
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

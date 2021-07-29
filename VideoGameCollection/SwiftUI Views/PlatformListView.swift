//
//  PlatformListView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/29/21.
//

import SwiftUI

struct PlatformListView: View {
    let platformDict: [Platform:[Int]]
    var body: some View {
        ForEach(Array(platformDict.keys), id: \.self){ platform in
            Section(header: Text(platform.name)){
                ForEach(platformDict[platform]!, id: \.self){ game in
                    GameCollectionRow(id: game)
                }
            }
        }
    }
}

struct PlatformListView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformListView(platformDict: [:])
    }
}

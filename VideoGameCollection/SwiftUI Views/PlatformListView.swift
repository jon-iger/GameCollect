//
//  PlatformListView.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/29/21.
//

import SwiftUI

/**
 List view that displays all gaming platforms the user may interact with based on data from the API
 */
struct PlatformListView: View {
    // MARK: Constants
    let platformDict: [Platform:[Int]]
    
    // MARK: SwiftUI Body
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

// MARK: Content Preview
struct PlatformListView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformListView(platformDict: [:])
    }
}

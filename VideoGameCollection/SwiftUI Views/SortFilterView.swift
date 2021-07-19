//
//  SortFilterView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/19/21.
//

import SwiftUI

struct SortFilterView: View {
    @State var exactToggle = false
    @State var platformSelection = String()
    var body: some View {
        Form{
            Toggle("Exact Search", isOn: $exactToggle)
            Picker("Platform", selection: $platformSelection){
                Text("Sample1").tag("1")
                Text("Sample2").tag("2")
            }
        }
    }
}

struct SortFilterView_Previews: PreviewProvider {
    static var previews: some View {
        SortFilterView()
    }
}

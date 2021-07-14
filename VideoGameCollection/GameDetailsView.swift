//
//  GameDetailsView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/12/21.
//

import SwiftUI

struct GameDetailsView: View {
    var id: Int
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                loadGameDetails()
            }
    }
    
    /**
     loadPlatformSelection: function responsible for loading the current list of platforms the API supports, and displaying them to the user
     parameters: none
     */
    func loadGameDetails() {
        //create the basic URL
        let urlString = "https://api.rawg.io/api/games/\(String(id))?key=3c7897d6c00a4f0fae76833a5c8e743c"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        print("Starting decoding...")
        //start our URLSession to get data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                //decode the data as a PlatformSelection objecct
                let decoder = JSONDecoder()
                if let details = try? decoder.decode(GameDetails.self, from: data){
                    print("Successfully decoded")
                    print(details.description)
                    //data parsing was successful, so return
                    return
                }
                
            }
        }.resume()  //call our URLSession
    }
}

struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(id: 0)
    }
}

//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 7/9/21.
//

import SwiftUI

struct AddGameView: View {
    @State var searchText = String()
    @State var displayText = String()
    var body: some View {
        let bindText = Binding<String>(
            get: { self.displayText},
            set: {
                self.displayText = $0
                var charArray = Array(self.displayText)
                var index = 0
                for char in charArray{
                    if char == " "{
                        charArray[index] = "-"
                    }
                    index += 1
                }
                searchText = String(charArray)
                gameSearch(searchText)
            }
        )
        Form{
            TextField("Search", text: bindText)
                .padding()
            
            Spacer()
        }
    }
    
    //API note: use - character to subsitutue for space characters, as the API does not allow spaces in URLs (bad URL warnings will appear in the console if this is done)
    func gameSearch(_ searchTerm: String) {
        let urlString = "https://api.rawg.io/api/games?key=3c7897d6c00a4f0fae76833a5c8e743c&search=\(searchTerm)"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                // we got some data back!
                //let str = String(decoding: data, as: UTF8.self)
                //print(str)
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(GameResults.self, from: data){
                    for game in items.results {
                        print(game)
                    }
                    print("\n")
                    return
                }
                
            }
            // if we're still here it means the request failed somehow
        }.resume()
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}

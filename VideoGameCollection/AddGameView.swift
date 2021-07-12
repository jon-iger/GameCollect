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
    @State var gameResults: GameResults = GameResults()
    @State var showExact: Bool = false
    @State var platformSelection = 0
    let platformValue = [0: "Nintendo Switch", 1: "GameCube"]
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
                gameSearch(searchText, showExact)
            }
        )
        let bindExact = Binding<Bool>(
            get: {self.showExact},
            set: {self.showExact = $0; gameSearch(searchText, showExact)}
        )
        Form{
            Section(header: Text("Filters")){
                Toggle("Exact Search", isOn: bindExact)
                Picker("Platform", selection: $platformSelection, content: { // <2>
                    Text("Nintendo Switch").tag(0)
                    Text("GameCube").tag(1)
                })
            }
            TextField("Search", text: bindText)
                .padding()
            Section(header: Text("Results")){
                List(gameResults.results, id: \.id){ game in
                    GameResultRow(title: game.name, platform: game.platforms[0].platform.name)
                }
            }
        }
        .navigationBarTitle("Add Game")
    }
    
    //API note: use - character to subsitutue for space characters, as the API does not allow spaces in URLs (bad URL warnings will appear in the console if this is done)
    func gameSearch(_ searchTerm: String, _ searchExact: Bool) {
        let urlString = "https://api.rawg.io/api/games?key=3c7897d6c00a4f0fae76833a5c8e743c&search=\(searchTerm)&search_exact=\(searchExact)"
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
                    gameResults = items
                    return
                }
                
            }
        }.resume()
    }
}

struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}

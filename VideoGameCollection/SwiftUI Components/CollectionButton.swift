//
//  CollectionButton.swift
//  VideoGameCollection
//
//  Created by Jonathon Lannon on 8/13/21.
//

import SwiftUI
import CloudKit

struct CollectionButton: View {
    @EnvironmentObject var gameObject: VideoGameCollection
    @State var partOfCollection: Bool
    @State var gameAlert: Bool = false
    let id: Int
    let name: String
    var body: some View {
        Button(partOfCollection ? "Remove from Collection" : "Add to Collection"){
            if partOfCollection{
                var index = 0
                for game in gameObject.gameCollection{
                    if game.gameId == id{
                        let oldGame = gameObject.gameCollection[index]
                        gameObject.gameCollection.remove(at: index)
                        VideoGameCollection.deleteiCloudGame(oldGame: oldGame)
                        partOfCollection = false
                        gameAlert = true
                    }
                    index += 1
                }
            }
            else{
                let newGame = Game()
                newGame.gameId = id
                newGame.dateAdded = Date()
                newGame.title = name
                newGame.recordID = CKRecord.ID(recordName: String(id))
                gameObject.gameCollection.append(newGame)
                VideoGameCollection.saveiCloudGame(newGame: newGame)
                partOfCollection = true
                gameAlert = true
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 25))
        .alert(isPresented: $gameAlert){
            Alert(title: Text("Success"), message: Text("Your change has been saved to your collection"), dismissButton: .default(Text("OK")))
        }
    }
}

struct CollectionButton_Previews: PreviewProvider {
    static var previews: some View {
        CollectionButton(partOfCollection: true, id: 0, name: "Lego")
    }
}

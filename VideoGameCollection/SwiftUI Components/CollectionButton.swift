//
//  CollectionButton.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 8/13/21.
//

import SwiftUI
import CloudKit

struct CollectionButton: View {
    @EnvironmentObject var cloudContainer: CloudContainer
    @State var partOfCollection: Bool
    @State var gameAlert: Bool = false
    let id: Int
    let name: String
    var body: some View {
        Button(partOfCollection ? "Remove from Collection" : "Add to Collection"){
            if partOfCollection{
                var index = 0
                for game in cloudContainer.gameCollection{
                    if game.gameId == id{
                        let oldGame = cloudContainer.gameCollection[index]
                        cloudContainer.gameCollection.remove(at: index)
                        CloudContainer.deleteCloudGame(oldGame: oldGame)
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
                cloudContainer.gameCollection.append(newGame)
                CloudContainer.saveCloudGame(newGame: newGame)
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

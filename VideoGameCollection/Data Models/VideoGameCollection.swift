//
//  VideoGameCollection.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/9/21.
//

import Foundation
import CloudKit

let container: CKContainer = CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection")
var iCloudStatus: Int = -1

class VideoGameCollection: ObservableObject{
    @Published var gameCollection: [Game]
    
    init(){
        self.gameCollection = []
    }
    
    static func loadiCloudGames()->VideoGameCollection{
        let finalCollect: VideoGameCollection = VideoGameCollection()
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Game", predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "id", "dateAdded"]
        
        var finalCollection: [Game] = []
        
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let newRecord):
                var record = newRecord
                let game = Game()
                game.title = record["title"]
                game.gameId = record["id"]
                game.recordID = record.recordID
                game.dateAdded = record["dateAdded"]
                finalCollection.append(game)
            case .failure(let error):
                print("\(String(describing: error))")
            }
        }
        
        operation.queryResultBlock = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Cloud load success!")
                    finalCollect.gameCollection = finalCollection
                case .failure(let error):
                    print("Cloud load failed!")
                    print("Heres the error! \(String(describing: error))")
                }
            }
        }
        container.privateCloudDatabase.add(operation)
        return finalCollect
    }
    
    static func saveiCloudGame(newGame: Game){
        let gameRecord = CKRecord(recordType: "Game", recordID: newGame.recordID)
        gameRecord["title"] = newGame.title as CKRecordValue
        gameRecord["dateAdded"] = newGame.dateAdded as CKRecordValue
        gameRecord["id"] = newGame.gameId as CKRecordValue
        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").privateCloudDatabase.save(gameRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Success in the Cloud!")
                }
            }
        }
    }
    
    static func deleteiCloudGame(oldGame: Game){
        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").privateCloudDatabase.delete(withRecordID: oldGame.recordID){(recordID, error) in
            if error == nil{
                print("Cloud delete success!")
            }
            else{
                print(error?.localizedDescription ?? "Nil")
            }
        }
    }
    
    static func bulkDeleteiCloudGames(oldRecords: [CKRecord.ID]){
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: oldRecords)
        operation.perRecordCompletionBlock = { record, error in
            if error == nil{
                print("One item deleted in the cloud!")
            }
            else{
                print(error?.localizedDescription ?? "Unknown error deleting one item")
            }
        }
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            if error == nil{
                print("All items deleted in the cloud!")
            }
            else{
                print(error?.localizedDescription ?? "Unknown error deleting all items")
            }
        }
        CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection").publicCloudDatabase.add(operation)
    }
    
    func isEmpty()->Bool{
        if self.gameCollection.count == 0{
            return true
        }
        else{
            return false
        }
    }
}

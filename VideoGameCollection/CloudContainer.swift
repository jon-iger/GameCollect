//
//  CloudContainer.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/9/21.
//

import Foundation
import CloudKit

let container: CKContainer = CKContainer(identifier: "iCloud.com.Jonathon-Lannon.VideoGameCollection")
var iCloudStatus: Int = -1

class CloudContainer: ObservableObject{
    @Published var gameCollection: [Game]
    
    init(){
        self.gameCollection = []
    }
    
    static func loadiCloudGames()->CloudContainer{
        let finalCollect: CloudContainer = CloudContainer()
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Game", predicate: pred)
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "id", "dateAdded"]
        
        var finalCollection: [Game] = []
        
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
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
        operation.perRecordProgressBlock = { record, recordSaved in
            if recordSaved == 1.0 {
                print("One item deleted in the cloud!")
            }
            else{
                print("\(record.recordID) \(recordSaved)% deleted.")
            }
        }
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print("All items deleted")
            case .failure(let error):
                print(error.localizedDescription)
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

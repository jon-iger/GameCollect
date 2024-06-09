//
//  ContentViewModel.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/8/24.
//

import Foundation
import CoreData

extension ContentView {
    @Observable
    class ContentViewModel {
        private var iCloudStatusCode: Int = -1
        public var iCloudStatusAlert = false
        public var errorMessage: String = ""
        enum errorCodes: String {
            case noStatusDetermined = "Could not determine status."
            case normalStatus = "iCloud Status Valid"
            case iCloudAccessError = "System restrictions have denied the user the ability to access iCloud on this device. Go to Settings to resolve the issue."
            case iCloudNotSignedIn = "No iCloud account is signed into on this device. Go to Settings to resolve this issue."
            case iCloudNotAvailable = "iCloud is not available at this time. Try again later."
            case unknownError = "Unknown error. Contact the developer for more support."
        }
        
        func checkCloudStatus() {
            container.accountStatus(completionHandler: {status, error in
                print("iCloud account status code \(status.rawValue)")
                let accountStatusCode = status.rawValue
                switch accountStatusCode {
                case 0:
                    self.errorMessage = "Could not determine status. Completion handler executed properly, but Apple could not determine the status."
                case 1:
                    print("Successful!")
                case 2:
                    self.errorMessage = "System restrictions have denied the user the ability to access iCloud on this device. Go to Settings to resolve the issue."
                case 3:
                    self.errorMessage = "No iCloud account is signed into on this device. Go to Settings to resolve this issue."
                case 4:
                    self.errorMessage = "iCloud is not available at this time. Try again later."
                default:
                    self.errorMessage = "Unknown error. Contact the developer for more support."
                    print("iCloud Account Status could not be determined")
                }
            })
            if iCloudStatusCode != 1 {
                iCloudStatusAlert.toggle()
            }
        }
    }
}

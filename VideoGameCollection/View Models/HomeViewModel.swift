//
//  HomeViewModel.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/8/24.
//

import Foundation
import CoreData

extension HomeView {
    @Observable
    class HomeViewModel {
        public var cloudStatusAlert = false
        public var errorMessage: String = ""
        
        /**
         Local function to check Cloud container status and update any binding state values in the HomeView
         */
        func updateCloudAlert() {
            DispatchQueue.main.async {
                CloudContainer.checkCloudStatus()
                if cloudStatus != 1 {
                    self.cloudStatusAlert.toggle()
                    self.errorMessage = ""
                    self.errorMessage = cloudMessage
                }
            }
        }
    }
}

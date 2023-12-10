//
//  Barcode.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/27/21.
//

import Foundation

struct BarcodeResults: Codable{
    var products: [BarcodeItem]
    
    struct BarcodeItem: Codable{
        var title: String
        var description: String
    }
}

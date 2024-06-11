//
//  APIAccess.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/10/24.
//

import Foundation

enum ServiceAPI: String {
    case rawg = "rawgAPIKey"
    case barcodeLookup = "barcodeLookupAPIKey"
    case bingSearch = "bingSearchAPIKey"
}

struct APIAccess {
    static func getAPIKey(environmentKey: String) -> String {
        if let key = ProcessInfo.processInfo.environment[environmentKey] {
            return key
        }
        return String()
    }
}

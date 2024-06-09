//
//  Bool.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 6/9/24.
//

import Foundation

extension Bool {
    var inverted: Self {
        get { !self }
        set { self = !newValue }
    }
}

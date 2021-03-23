//
//  Bool.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 23/03/2021.
//

import Foundation

extension Optional {
    var notNil: Bool {
        self != nil
    }
}

extension Optional where Wrapped == String {
    var emptyOrNil: Bool {
        if let unwrapped = self {
            return unwrapped.isEmpty
        }
        
        return true
        
    }
}

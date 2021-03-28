//
//  API+Profile.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import Foundation

extension API {
    
    static func getCurrentUserProfile() -> Endpoint{
        return Endpoint(
            method: .get,
            path: "/me",
            queryParameters: nil,
            headers:nil,
            body: nil,
            authorizationNeeded: true
        )
    }
    
}

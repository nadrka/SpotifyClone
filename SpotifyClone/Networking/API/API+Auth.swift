//
//  API+Auth.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 23/03/2021.
//

import Foundation

extension API {
    
    static func getToken(code: String) -> Endpoint{
        return Endpoint(
            method: .post,
            path: "/token",
            queryParameters: nil,
            headers: [
                "Content-type": "application/x-www-form-urlencoded",
                "Authorization": "Basic \(AuthManager.Constants.basicToken64)"
            ],
            body: [
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": AuthManager.Constants.redirectURI,
            ],
            authorizationNeeded: false
        )
    }
    
    static func getToken(refreshToken: String) -> Endpoint{
        return Endpoint(
            method: .post,
            path: "/token",
            queryParameters: nil,
            headers: [
                "Content-type": "application/x-www-form-urlencoded",
                "Authorization": "Basic \(AuthManager.Constants.basicToken64)"
            ],
            body: [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken,
            ],
            authorizationNeeded: false
        )
    }
}

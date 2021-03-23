//
//  Auth.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 23/03/2021.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String?
    let expiresIn: Int
    let scope: String
    let tokenType: String
}

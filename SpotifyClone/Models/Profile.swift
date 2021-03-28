//
//  Profile.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import Foundation

struct Profile: Decodable {
    let id: String
    let country: String
    let displayName: String
    let email: String
    struct Followers: Decodable {
        let total: Int
    }
    let followers: Followers
    let images: [Image]
}

struct Image: Codable {
    let height: Double?
    let width: Double?
    let url: String
}

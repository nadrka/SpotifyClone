//
//  Playlist.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation

struct Playlist: Decodable {
    let id: ID
    let name: String
    let description: String
    let collaborative: Bool
    let images: [Image]
    let owner: Owner
}

extension Playlist {
    struct Owner: Decodable {
        let id: ID
        let href: String
    }
}

extension Playlist {
    struct List: Decodable {
        let items: [Playlist]
    }
}


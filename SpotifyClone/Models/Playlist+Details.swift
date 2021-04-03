//
//  Playlist+Details.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 03/04/2021.
//

import Foundation

extension Playlist {
    struct Details: Decodable {
        let name: String
        let tracks: Track.Response.List
    }
}

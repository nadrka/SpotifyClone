//
//  Track.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation

struct Track: Decodable {
    let id: ID
    let name: String
    let artists: [Artist]
    let trackNumber: Int
    let discNumber: Int
    let durationMs: Int
    let isPlayable: Bool?
    let explicit: Bool
    let album: Album
}

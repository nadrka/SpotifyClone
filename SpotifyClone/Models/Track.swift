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
    let album: Album?
}

extension Track {
    struct List: Decodable {
//        let href: String
        let items: [Track]
    }
}

extension Track: Hashable, Equatable {
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}




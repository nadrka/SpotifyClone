//
//  Album+Details.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 01/04/2021.
//

import Foundation

extension Album {
    struct Details: Decodable {
        let artists: [Artist]
        let popularity: Int
        let releaseDate: String
        let tracks: Track.List
    }
}

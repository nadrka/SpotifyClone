//
//  Album.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation

typealias ID = String

struct Album: Decodable {
    let id: ID
    let name: String
    let artists: [Artist]
    let images: [Image]
    let totalTracks: Int
    let releaseDate: String
    private let albumType: String

    var type: Typek? {
        Typek(rawValue: albumType)
    }

}

extension Album {
    struct List: Decodable {
        let items: [Album]
    }
}

extension Album {
    enum Typek: String {
        case single
    }
}

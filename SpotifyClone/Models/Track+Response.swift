//
//  Track+Response.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 03/04/2021.
//

import Foundation


extension Track {
    struct Response: Decodable {
        let track: Track
    }
}

extension Track.Response {
    struct List: Decodable {
        let items: [Track.Response]
    }
}

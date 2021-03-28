//
//  Browse.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation

struct Browse {
    struct NewRealesesResponse: Decodable {
        let albums: Album.List
    }
    
    struct FeaturedPlaylistResponse: Decodable {
        let message: String
        let playlists: Playlist.List
    }
    
    struct RecommandationResponse: Decodable {
        let tracks: [Track]
    }
    
    struct GenresResponse: Decodable {
        let genres: [String]
    }
}


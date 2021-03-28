//
//  API+Browse.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation

extension API {
    static func getAllNewReleases(limit: Int?) -> Endpoint {
        let queryParameters = limit.notNil ? ["limit": "\(limit!)"] : nil
        return Endpoint(
            method: .get,
            path: "/browse/new-releases",
            queryParameters: queryParameters,
            headers:nil,
            body: nil,
            authorizationNeeded: true
        )
    }
    
    static func getFeaturedPlaylists(limit: Int?) -> Endpoint {
        let queryParameters = limit.notNil ? ["limit": "\(limit!)"] : nil
        return Endpoint(
            method: .get,
            path: "/browse/featured-playlists",
            queryParameters: queryParameters,
            headers:nil,
            body: nil,
            authorizationNeeded: true
        )
    }
    
    static func getRecommendation(limit: Int?, genreSeeds: String) -> Endpoint {
        var queryParameters = ["seed_genres": genreSeeds]
        if let limit = limit {
            queryParameters["limit"] = "\(limit)"
        }
        return Endpoint(
            method: .get,
            path: "/recommendations",
            queryParameters: queryParameters,
            headers:nil,
            body: nil,
            authorizationNeeded: true
        )
    }
    
    static func getGenreSeeds() -> Endpoint {
        return Endpoint(
            method: .get,
            path: "/recommendations/available-genre-seeds",
            queryParameters: nil,
            headers:nil,
            body: nil,
            authorizationNeeded: true
        )
    }
    
}

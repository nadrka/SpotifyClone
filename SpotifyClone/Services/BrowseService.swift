//
//  BrowseService.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation
import Combine

class BrowseService {
    let client: Client
    
    init(client: Client = MainClient()) {
        self.client = client
    }
    
    func getAllNewReleases(limit: Int? = nil) -> AnyPublisher<Realeses, ApiError>{
        let endpoint = API.getAllNewReleases(limit: limit)
        
        return client.call(type: Realeses.self, endpoint: endpoint)
    }
    
    func getFeaturedPlaylists(limit: Int? = nil) -> AnyPublisher<Playlist, ApiError>{
        let endpoint = API.getFeaturedPlaylists(limit: limit)
        
        return client.call(type: Playlist.self, endpoint: endpoint)
    }
    
    func getRecommendation(limit: Int? = nil) -> AnyPublisher<Recommandation, ApiError>{
        let endpoint = API.getGenreSeeds()
    
        return client.call(type: Genres.self, endpoint: endpoint)
            .flatMap { genres in
                return self.recommandationRequest(limit: limit, genres: genres)
            }.eraseToAnyPublisher()
    }
    
    private func recommandationRequest(limit: Int?, genres: Genres) -> AnyPublisher<Recommandation, ApiError> {
        let genreSeeds = getRandomGenreSeeds(reponse: genres)
        let endpoint = API.getRecommendation(limit: limit, genreSeeds: genreSeeds)
        
        return client.call(type: Recommandation.self, endpoint: endpoint)
    }
    
    private func getRandomGenreSeeds(reponse: Genres) -> String {
        let genres = reponse.genres
        var seeds = Set<String>()
        
        while seeds.count < 5 {
            if let random = genres.randomElement() {
                seeds.insert(random)
            }
        }
        
        return seeds.joined(separator: ",")
    }
}

extension BrowseService {
    typealias Realeses = Browse.NewRealesesResponse
    typealias Playlist = Browse.FeaturedPlaylistResponse
    typealias Recommandation = Browse.RecommandationResponse
    typealias Genres = Browse.GenresResponse
}

//
//  PlaylistDetailsViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 03/04/2021.
//

import Foundation
import Combine

class PlaylistDetailsViewModel {
    private var cancellables = Set<AnyCancellable>()
    let state = PassthroughSubject<State, Never>()
    
    let playlist: Playlist
    let browseService: BrowseService
    var details: Playlist.Details?
    
    init(playlist: Playlist, browseService: BrowseService = BrowseService()) {
        self.playlist = playlist
        self.browseService = browseService
    }
        
    func fetchDetails() {
        state.send(.loading)
        
        browseService.getPlaylistDetails(playlist: playlist)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.state.send(.error)
                    print(error)
                }
            }) { [weak self] details in
                self?.details = details
                self?.state.send(.loaded)
            }.store(in: &cancellables)
    }
}


// MARK: Datasource
extension PlaylistDetailsViewModel {
    var tracks: [Track] {
        details?.tracks.items.compactMap {
            $0.track
        } ?? []
    }
    
    var numberOfTracks: Int {
        tracks.count
    }
    
    func getTrack(for row: Int) -> Track? {
        guard tracks.indices.contains(row) else {
            return nil
        }
        
        return tracks[row]
    }
}

